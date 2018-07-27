//
//  Bucket.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

import Foundation
import KeychainSwift

@objc public class Bucket: NSObject {
    
    // Create a singleton for the Bucket object.
    @objc public static let shared = Bucket()
    
    // Instantiate Keychain to store small sensitive information such as the retailerId and retailerSecret.
    private var keychain = KeychainSwift()
    
    // Set the environment that defines which endpoint we will hit for either sandbox or the production endpoint.
    @objc public dynamic var environment : DeploymentEnvironment = .development
    
    // Set our date formatter for sending the interval ids.
    fileprivate var dateFormatter = DateFormatter(format: "yyyyMMdd")
    
    private override init() {
        super.init()
        
        // Make sure our interval ids are using the UTC datestamp.
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    
    // MARK: Bucket Functions
    // Register the device with your own specified terminalId.
    @objc public func registerDevice(with terminalId: String, _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let retailerId = Bucket.Credentials.retailerId, let _ = Bucket.Credentials.retailerSecret else {
            completion(false, BucketError.invalidRetailer)
            return
        }
        
        var request = URLRequest(url: URL.registerTerminal)
        request.setMethod(.post)
        request.setBody(["retailerId": retailerId, "terminalId": terminalId])
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let registerDeviceResponse = try JSONDecoder().decode(RegisterTerminalResponse.self, from: data)
                    
                    // Save the apiKey as the retailerSecret and save the specified terminalId.
                    Bucket.Credentials.retailerSecret = registerDeviceResponse.apiKey
                    Bucket.Credentials.terminalId = terminalId
                    
                    completion(true, nil)
                } catch let error {
                    completion(false, error)
                }
            } else {
                do {
                    // Map the json response to the model class.
                    let bucketError = try JSONDecoder().decode(BucketError.self, from: data)
                    completion(false, bucketError.asError(response?.code))
                } catch let error {
                    completion(false, error)
                }
            }
            }.resume()
        
        print(URL.registerTerminal)
    }
    
    // Fetch the bill denominations for the retailer and cache them.
    @objc public func fetchBillDenominations(for currencyCode: BillDenomination, _ completion: ((_ success: Bool, _ error : Error?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: URL.billDenominations) { (data, response, error) in
            guard let data = data else {
                completion?(false, error)
                return
            }
            
            // We successfully logged in. We should go and check for the denominations returned.
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let currencies = try JSONDecoder().decode(FetchBillDenominationsResponse.self, from: data).currencies
                    
                    // Find that specific currencyCode in the result and store if found.
                    // We use the filter method here instead of loop to take advantage of iOS's power.
                    if let currency = currencies?.filter({ $0.currencyCode == currencyCode.stringValue }).first, let denoms = currency.commonDenominations {
                        
                        // Store its denominations and if such currency should use natural change function.
                        UserDefaults.standard.denoms = denoms
                        UserDefaults.standard.usesNaturalChangeFunction = currency.usesNaturalChangeFunction ?? false
                        
                        completion?(true, nil)
                    } else {
                        completion?(false, BucketError.noCurrencyFound)
                    }
                } catch let error {
                    completion?(false, error)
                }
            } else {
                completion?(false, error)
            }
            }.resume()
    }
    
    // Close the specified interval. This initiates an ACH bank transfer from the retailer to Bucket.
    @objc public func close(intervalId: String, _ completion: ((_ response: CloseIntervalResponse?, _ success: Bool, _ error: Error?) -> Void)? = nil) {
        guard let retailerId = Bucket.Credentials.retailerId, let retailerSecret = Bucket.Credentials.retailerSecret else {
            completion?(nil, false, BucketError.invalidRetailer)
            return
        }
        
        // Okay, they have their retailer id and retailer secret. Lets make the request.
        var url = URL.closeInterval
        url.appendPathComponent(retailerId)
        url.appendPathComponent(intervalId)
        
        var request = URLRequest(url: url)
        request.setMethod(.get)
        request.addValue(retailerSecret, forHTTPHeaderField: "x-functions-key")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil, false, error)
                return
            }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let closeIntervalResponse = try JSONDecoder().decode(CloseIntervalResponse.self, from: data)
                    completion?(closeIntervalResponse, true, nil)
                } catch let error {
                    completion?(nil, false, error)
                }
            } else {
                do {
                    // Map the json response to the model class.
                    let bucketError = try JSONDecoder().decode(BucketError.self, from: data)
                    completion?(nil, false, bucketError.asError(response?.code))
                } catch let error {
                    completion?(nil, false, error)
                }
            }
            }.resume()
    }
    
    // Return the bucket amount based on the dollar and change amount.
    @objc public func bucketAmount(for changeDueBack: Int) -> Int {
        var bucketAmount = changeDueBack
        
        let denoms = UserDefaults.standard.denoms
        let usesNaturalChangeFunction = UserDefaults.standard.usesNaturalChangeFunction
        
        if usesNaturalChangeFunction {
            for denom in denoms {
                bucketAmount = bucketAmount % denom
            }
        } else {
            while bucketAmount > 100 {
                bucketAmount = bucketAmount % 100
            }
        }
        
        return bucketAmount
    }
    
    @objc public func bucketAmount(forDecimal changeDueBack: Double) -> Int {
        let roundedAmountInt = Int(String(format: "%.2f", changeDueBack).replacingOccurrences(of: ".", with: ""))!
        return bucketAmount(for: roundedAmountInt)
    }
    
    // MARK: Bucket Nested Classes
    @objc public class Transaction: NSObject {
        @objc public dynamic var amount: Int
        @objc public dynamic var totalTransactionAmount: Int = 0
        @objc public dynamic var intervalId: String
        @objc public dynamic var locationId: String?
        @objc public dynamic var clientTransactionId: String
        // @objc public dynamic var terminalId: String?
        
        // You will need to initialize a transaction with an amount, and a client transaction/order/sale id
        @objc public init(amount: Int, clientTransactionId: String) {
            self.amount = amount
            self.clientTransactionId = clientTransactionId
            
            // Take care of all the values that we would always send.
            self.intervalId = Date.now.toYYYYMMDD
        }
        
        @objc public func create(_ completion: @escaping (_ response: CreateTransactionResponse?, _ success: Bool, _ error: Error?) -> Void) {
            guard let retailerId = Bucket.Credentials.retailerId, let retailerSecret = Bucket.Credentials.retailerSecret else {
                completion(nil, false, BucketError.invalidRetailer)
                return
            }
            
            guard let terminalId = Bucket.Credentials.terminalId else {
                completion(nil, false, BucketError.noIntervalId)
                return
            }
            
            // Return an error if the bucket amount returned is zero
            if self.amount == 0 {
                completion(nil, false, BucketError.zeroTransaction)
                return
            }
            
            // Prepare for a JSON body request param
            var json : [String: Any] = .init()
            json["amount"] = self.amount
            if totalTransactionAmount != 0 { json["totalTransactionAmount"] = self.totalTransactionAmount }
            json["intervalId"] = self.intervalId
            if let locationId = self.locationId { json["locationId"] = locationId }
            json["clientTransactionId"] = self.clientTransactionId
            json["terminalId"] = terminalId
            
            var request = URLRequest(url: URL.createTransaction.appendingPathComponent(retailerId))
            request.setMethod(.post)
            request.setBody(json)
            
            request.addValue(retailerSecret, forHTTPHeaderField: "x-functions-key")
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completion(nil, false, error)
                    return
                }
                
                if response.isSuccess {
                    do {
                        // Map the json response to the model class.
                        let createTransactionResponse = try JSONDecoder().decode(CreateTransactionResponse.self, from: data)
                        completion(createTransactionResponse, true, nil)
                    } catch let error {
                        completion(nil, false, error)
                    }
                } else {
                    do {
                        // Map the json response to the model class.
                        let bucketError = try JSONDecoder().decode(BucketError.self, from: data)
                        completion(nil, false, bucketError.asError(response?.code))
                    } catch let error {
                        completion(nil, false, error)
                    }
                }
                }.resume()
        }
    }
    
    @objc public class Credentials: NSObject {
        // This is the client id of the retailer. This is used to authorize requests with Bucket.
        @objc public static var retailerId : String? {
            get {
                return Bucket.shared.keychain.get("BUCKETID")
            }
            set {
                if newValue.isNil {
                    Bucket.shared.keychain.delete("BUCKETID")
                } else {
                    Bucket.shared.keychain.set(newValue!, forKey: "BUCKETID")
                }
            }
        }
        
        // This is the client secret of the retailer. This is used to authorize requests with Bucket.
        @objc public static var retailerSecret : String? {
            get {
                return Bucket.shared.keychain.get("BUCKETSECRET")
            }
            set {
                if newValue.isNil {
                    Bucket.shared.keychain.delete("BUCKETSECRET")
                } else {
                    Bucket.shared.keychain.set(newValue!, forKey: "BUCKETSECRET")
                }
            }
        }
        
        // This is the terminal id of this device/register. This is used to make valid transaction requests with Bucket.
        // You will need to register this terminal or device with your defined id.
        @objc public static var terminalId : String? {
            get {
                return Bucket.shared.keychain.get("BUCKETTERMINALID")
            }
            set {
                if newValue.isNil {
                    Bucket.shared.keychain.delete("BUCKETTERMINALID")
                } else {
                    Bucket.shared.keychain.set(newValue!, forKey: "BUCKETTERMINALID")
                }
            }
        }
    }
}

public extension Date {
    
    static var now : Date {
        return Date()
    }
    
    fileprivate var toYYYYMMDD : String {
        return Bucket.shared.dateFormatter.string(from: self)
    }
}

//
//  Bucket.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

import Foundation
import Strongbox

@objc public class Bucket: NSObject {
    
    // Create a singleton for the Bucket object.
    @objc public static let shared = Bucket()
    
    // Instantiate Keychain to store small sensitive information such as the retailerCode and terminalSecret.
    private var keychain = Strongbox()
    
    // Set the environment that defines which endpoint we will hit for either sandbox or the production endpoint.
    @objc public dynamic var environment: DeploymentEnvironment = .development
    
    // Set our date formatter for sending the interval ids.
    fileprivate var dateFormatter = DateFormatter(format: "yyyyMMdd")
    
    private override init() {
        super.init()
        
        // Make sure our interval ids are using the UTC datestamp.
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    
    // MARK: - Bucket Functions
    /// Registers a new device with Bucket to go and create your transactions.
    /// - Parameter countryId: This is the **numeric** country id, or the **alpha** two letter country code.
    @objc public func registerTerminal(countryCode: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let retailerId = Bucket.Credentials.retailerCode else {
            completion(false, BucketError.invalidRetailer)
            return
        }
        
        // This device id changes whenever you uninstall and reinstall the app.
        // We save the value to the keychain only once and when it's nil.
        // The next time they uninstall and reinstall, we still have the last known value.
        if Bucket.Credentials.terminalId.isNil {
            Bucket.Credentials.terminalId = UIDevice.current.identifierForVendor!.uuidString
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("registerterminal")
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.addHeader("countryId", countryCode.lowercased())
        request.addHeader("retailerId", retailerId)
        request.setBody(["terminalId": Bucket.Credentials.terminalId!])
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(RegisterTerminalResponse.self, from: data)
                    
                    // Save the apiKey as the terminalSecret.
                    Bucket.Credentials.terminalSecret = response.apiKey
                    
                    Bucket.Credentials.retailerInfo = RetailerInfo(
                        response.retailerName,
                        response.retailerPhone,
                        response.address?.address1,
                        response.address?.address2,
                        response.address?.address3,
                        response.address?.postalCode,
                        response.address?.city,
                        response.address?.state,
                        countryCode.lowercased()
                    )
                    
                    completion(true, nil)
                } catch let error {
                    completion(false, error)
                }
            } else {
                let bucketError = try? JSONDecoder().decode(BucketError.self, from: data)
                completion(false, bucketError?.asError(response?.code) ?? BucketError.unknown)
            }
            }.resume()
    }
    
    /// Gathers the bill denominations for the the retailers country, in order to calculate the change using our natural change function.
    @objc public func fetchBillDenominations(completion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {
        guard let countryCode = Bucket.Credentials.retailerInfo?.countryCode else {
            completion?(false, BucketError.invalidCountryCode)
            return
        }
        
        // We think we don't have to make an API call for the US.
        if countryCode.lowercased() == "us" {
            Bucket.Credentials.usesNaturalChangeFunction = true
            Bucket.Credentials.denoms = [100, 50, 20, 10, 5, 2]
            completion?(true, nil)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("billDenoms")
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.addHeader("countryId", countryCode)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(false, error)
                return
            }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(FetchBillDenominationsResponse.self, from: data)
                    
                    Bucket.Credentials.usesNaturalChangeFunction = response.usesNaturalChangeFunction ?? false
                    Bucket.Credentials.denoms = response.denominations ?? nil
                    
                    completion?(true, nil)
                } catch let error {
                    completion?(false, error)
                }
            } else {
                let bucketError = try? JSONDecoder().decode(BucketError.self, from: data)
                completion?(false, bucketError?.asError(response?.code) ?? BucketError.unknown)
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
            guard let retailerId = Bucket.Credentials.retailerCode, let retailerSecret = Bucket.Credentials.terminalSecret else {
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
        // MARK: - Public
        /// This is the **retailer code** creating the transaction.
        @objc public static var retailerCode: String? {
            get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_RETAILER_CODE") as? String }
            set {
                if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_RETAILER_CODE") }
                else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_RETAILER_CODE") }
            }
        }
        
        /// This contains the information about the retailer such as the phone number, adress, and etc.
        @objc public static var retailerInfo: RetailerInfo? {
            get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_RETAILER_INFO") as? RetailerInfo}
            set {
                if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_RETAILER_INFO") }
                else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_RETAILER_INFO") }
            }
        }
        
        // MARK: - Private
        /// This is the terminal secret of the retailer. This is used to authorize requests with Bucket.
        fileprivate static var terminalSecret: String? {
            get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_TERMINAL_SECRET") as? String }
            set {
                if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_TERMINAL_SECRET") }
                else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_TERMINAL_SECRET") }
            }
        }
        
        /// This is the **serial number** of the terminal or device creating the transaction.
        fileprivate static var terminalId: String? {
            get { return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_TERMINAL_ID") as? String }
            set {
                if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_TERMINAL_ID") }
                else { _ = Bucket.shared.keychain.archive(newValue!, key: "BUCKET_TERMINAL_ID") }
            }
        }
        
        fileprivate static var usesNaturalChangeFunction: Bool {
            get {
                return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_USES_NATURAL_CHANGE") as? Bool ?? false
            }
            set {
                _ = Bucket.shared.keychain.archive(newValue, key: "BUCKET_USES_NATURAL_CHANGE")
            }
        }
        
        fileprivate static var denoms: [Double]? {
            get {
                return Bucket.shared.keychain.unarchive(objectForKey: "BUCKET_DENOMS") as? [Double]
            }
            set {
                if newValue.isNil { Bucket.shared.keychain.remove(key: "BUCKET_DENOMS") }
                _ = Bucket.shared.keychain.archive(newValue, key: "BUCKET_DENOMS")
            }
        }
    }
}

public extension Date {
    static var now: Date {
        return Date()
    }
    
    fileprivate var toYYYYMMDD: String {
        return Bucket.shared.dateFormatter.string(from: self)
    }
}

//
//  Bucket.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

import Foundation
import KeychainSwift

@objc public class Bucket: NSObject {
    
    // This is the singleton for the Bucket object.
    @objc public static let shared = Bucket()
    
    // This is used to store small sensitive information such as the retailerId and retailerSecret.
    private var keychain : KeychainSwift = KeychainSwift()
    
    private override init() {
        super.init()
        
        // Make sure our interval ids are using the UTC datestamp.
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    
    // This is our date formatter for sending the interval ids.
    fileprivate var dateFormatter : DateFormatter = DateFormatter(format: "yyyyMMdd")
    
    // This is the denominations of the dollar bills in the register for this retailer.
    @objc public dynamic var denominations : [Int] {
        get {
            return UserDefaults.standard.denominations ?? [10000, 5000, 2000, 1000, 500, 200, 100]
        }
        set {
            UserDefaults.standard.denominations = newValue
        }
    }
    
    // This is the environment that defines which endpoint we will hit for either sandbox or the production endpoint.
    @objc public dynamic var environment : DeploymentEnvironment = .development
    
    private var useNaturalChangeFunction : Bool {
        get {
            return UserDefaults.standard.object(forKey: "usesNaturalChangeFunction") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "usesNaturalChangeFunction")
        }
    }
    
    // This function returns the bucket amount based on the dollar and change amount.
    @objc public func bucketAmount(for changeDueBack: Int) -> Int {
        var bucketAmount = changeDueBack
        
        if self.useNaturalChangeFunction {
            for denom in self.denominations {
                bucketAmount = bucketAmount % denom
            }
        } else {
            while bucketAmount > 100 {
                bucketAmount = bucketAmount % 100
            }
        }
        return bucketAmount
    }
    
    // This function will close the specified interval. This initiates an ACH bank transfer from the retailer to Bucket.
    @objc public func close(interval: String, _ completion: ((_ success: Bool, _ error: Error?)->Void)?=nil) {
        
        guard let clientSecret = Bucket.Credentials.retailerSecret, let clientId = Bucket.Credentials.retailerId else {
            completion?(false, BucketError.invalidCredentials)
            return
        }
        
        // Okay, they have their client id and client secret.  Lets make the request.
        var theURL = URL.close.interval
        theURL.appendPathComponent("transaction")
        theURL.appendPathComponent(clientId)
        
        var request = URLRequest(url: theURL)
        request.setMethod(.get)
        request.addValue(clientSecret, forHTTPHeaderField: "x-functions-key")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let bucketError = data?.bucketError {
                completion?(response.isSuccess, bucketError)
            } else {
                completion?(response.isSuccess, error)
            }
            }.resume()
    }
    
    // This function fetches the bill denominations for the retailer and caches them for the Bucket class.
    @objc public func fetchBillDenominations(_ CurrencyCode : BillDenomination, completion: @escaping (_ success: Bool, _ error : Error?) -> Void) {
        
        // This is just the URL for the bill denominations. This does not change between dev and production.
        let url = URL.Retail.billDenominations
        
        // We default to USD.
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if response.isSuccess {
                
                // We successfully logged in, we should go and check for the denominations and returned.
                if let json = data?.asJSON {
                    
                    // We have an array of the currencies based on the currency code, lets grab the correct currency code.
                    if let currencies = json["currencies"] as? [[String:Any]] {
                        
                        for currency in currencies {
                            // Get the currency code.
                            let currencyCode = currency["currencyCode"].stringValue
                            // If it is not the correct one, lets continue looping.
                            if currencyCode != CurrencyCode.stringValue { continue }
                            
                            // Finish processing if it is the correct code.
                            if currency["useNaturalChangeFunction"] as? Bool == true {
                                self.useNaturalChangeFunction = true
                                if let denoms = currency["commonDenominations"] as? [Int] {
                                    self.denominations = denoms
                                }
                            } else {
                                self.useNaturalChangeFunction = false
                            }
                        }
                    }
                }
                // Return the completion.
                completion(response.isSuccess, error)
            } else if let bucketError = data?.bucketError {
                completion(response.isSuccess, bucketError)
            } else {
                completion(response.isSuccess, error)
            }
        }.resume()
    }
    
    @objc public class Retailer : NSObject {
        
        // This function will log in the retailer with their username and password. This should go and fetch the clientId and clientSecret for that retailer account.
        @objc public static func logInWith(password: String, username: String, _ completion: @escaping (_ success: Bool, _ error: Error?)->Void) {
            completion(false, NSError(domain: "none", code: 400, userInfo: [NSLocalizedDescriptionKey:"Retailer login is not supported just yet."]))
        }
    }
    
    @objc public class Transaction : NSObject {
        
        // This is the primary key for the transaction table.
        @objc public dynamic var bucketTransactionId : String?
        
        @objc public dynamic var customerCode : String?
        
        // This is the URL for the qr code, in order for the user to redeem their bucket change.
        @objc public dynamic var qrCodeContent : URL?
        
        // This is defined by the retailer.  This is used if the retailer has multiple locations for their retailer account.
        @objc public dynamic var locationId : String?
        
        // This is the hardware id of the POS terminal or device.
        @objc public dynamic var terminalId : String?
        
        // @objc public dynamic var totalAmount : Int
        
        // This returns the amount for the transaction in an integer form.  1000 would be $10.00
        @objc public dynamic var amount : Int
        
        // This returns the client transaction id, that being the id for the order or sale.
        // @objc public dynamic var clientTransactionId : String
        
        // This is associated with the day that the store has created the transaction.
        @objc public dynamic var intervalId : String!
        
        // You will need to initialize a transaction with an amount, and a transaction/order/sale id.
        @objc public init(amount : Int/* , clientTransactionId : String, totalAmount : Int */) {
            self.amount = amount
            self.terminalId = Bucket.Credentials.terminalId
            // self.totalAmount = totalAmount
            // self.clientTransactionId = clientTransactionId
            
            // Now lets set the terminalId - otherwise known as the unique identifier for the hardware.
            // if let uuid = UIDevice.current.identifierForVendor { self.terminalId = uuid.uuidString }
        }
        
        private var toJSON : [String:Any] {
            var json : [String:Any] = .init()
            
            // Take care of all the values that we would always send.
            self.intervalId = Date.now.toYYYYMMDD
            json["amount"] = self.amount
            // json["clientTransactionId"] = self.clientTransactionId
            json["intervalId"] = self.intervalId
            // json["totalTransactionAmount"] = self.totalAmount
            
            if (!self.locationId.isNil) { json["locationId"] = self.locationId! }
            if (!self.customerCode.isNil) { json["customerCode"] = self.customerCode! }
            if (!self.terminalId.isNil) { json["terminalId"] = self.terminalId! }
            
            return json
        }
        
        func updateWith(_ json : [String:Any]?) {
            if json.isNil { return }
            self.customerCode = json!["customerCode"].stringValue
            self.bucketTransactionId = json!["bucketTransactionId"].stringValue
            self.qrCodeContent = json!["qrCodeContent"].urlValue
        }
        
        @objc public func create(_ completion: @escaping (_ success : Bool, _ error: Error?)->Void) {
            
            guard let clientSecret = Bucket.Credentials.retailerSecret, let clientId = Bucket.Credentials.retailerId else {
                completion(false, BucketError.invalidCredentials)
                return
            }
            
            var theURL = URL.Transaction.base
            theURL.appendPathComponent("transaction")
            theURL.appendPathComponent(clientId)
            
            var request = URLRequest(url: theURL)
            request.setMethod(.post)
            request.setJSONBody(self.toJSON)
            
            request.addValue(clientSecret, forHTTPHeaderField: "x-functions-key")
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if response.isSuccess {
                    // First we need to update the transaction object with the json data.
                    self.updateWith(data?.asJSON)
                    // Return the completion as successful.
                    completion(response.isSuccess, error)
                } else if let bucketError = data?.bucketError {
                    completion(response.isSuccess, bucketError)
                }  else {
                    completion(response.isSuccess, error)
                }
            }.resume()
        }
    }
    
    @objc public class Credentials : NSObject {
        // This is the client id of the retailer. This is used to authorize requests with Bucket.
        @objc public  /*private(set)*/ static var retailerId : String? {
            get {
                return Bucket.shared.keychain.get("BUCKETID")
            }
            set {
                // Implement the setter.
                if newValue.isNil {
                    Bucket.shared.keychain.delete("BUCKETID")
                } else {
                    Bucket.shared.keychain.set(newValue!, forKey: "BUCKETID")
                }
            }
        }
        
        // This is the client secret of the retailer. This is used to authorize requests with Bucket.
        @objc public  /*private(set)*/ static var retailerSecret : String? {
            get {
                return Bucket.shared.keychain.get("BUCKETSECRET")
            }
            set {
                // Implement the setter.
                if newValue.isNil {
                    Bucket.shared.keychain.delete("BUCKETSECRET")
                } else {
                    Bucket.shared.keychain.set(newValue!, forKey: "BUCKETSECRET")
                }
            }
        }
        
        // This is the terminal id of this device/register. This is used to make valid transaction requests with Bucket.
        // You will need to register this terminal or device with your defined id.
        @objc public  /*private(set)*/ static var terminalId : String? {
            get {
                return Bucket.shared.keychain.get("BUCKETTERMINALID")
            }
            set {
                // Implement the setter.
                if newValue.isNil {
                    Bucket.shared.keychain.delete("BUCKETTERMINALID")
                } else {
                    Bucket.shared.keychain.set(newValue!, forKey: "BUCKETTERMINALID")
                }
            }
        }
    }
    
}

class BucketError: Error { private init() {} }

public extension Date {
    static var now : Date {
        return Date()
    }
    fileprivate var toYYYYMMDD : String {
        return Bucket.shared.dateFormatter.string(from: self)
    }
}

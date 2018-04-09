//
//  Bucket.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

import Foundation
import KeychainSwift

@objc public class Bucket: NSObject {
    /// This is the singleton for the Bucket object.
    @objc public static let shared = Bucket()
    private override init() { super.init() }
    
    /// This is our date formatter for sending the interval ids.
    fileprivate var dateFormatter : DateFormatter = DateFormatter(format: "yyyyMMdd")
    /// This is the denominations of the dollar bills in the register for this retailer:
    private var denominations : [Int] {
        return UserDefaults.standard.denominations ?? [10000, 5000, 2000, 1000, 500, 200, 100]
    }
    private var keychain : KeychainSwift = KeychainSwift()
    
    /// This is the environment that defines which endpoint we will hit for either sandbox or the production endpoint.
    @objc public var environment : DeploymentEnvironment = .Development
    
    /// This function returns the bucket amount based on the dollar & change amount.
    @objc public func bucketAmount(for changeDueBack: Int) -> Int {
        var bucketAmount = changeDueBack
        for denom in self.denominations {
            bucketAmount = bucketAmount % denom
        }
        return bucketAmount
    }
    
    /// This function fetches the bill denominations for the retailer and caches them for the Bucket class.
    @objc public func fetchBillDenominations(completion: @escaping (_ success: Bool, _ error : Error?)->Void) {
        
        // This returns the base URL depending on the set environment:
        var url = URL.Retail.base
        // Append for the correct endpoint here:
        url.appendPathComponent("")
        
        let request = URLRequest(url: URL(string: "https://example.com")!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if response.isSuccess {
                // We successfully logged in, we should go & check for the denominations & returned:
                if let json = data?.asJSON {
                    UserDefaults.standard.denominations = json["denominations"] as? [Int]
                }
                // Return the completion:
                completion(response.isSuccess, error)
            } else if let bucketError = data?.bucketError {
                completion(response.isSuccess, bucketError)
            } else {
                completion(response.isSuccess, error)
            }
        }.resume()
    }
    
    @objc public class Retailer : NSObject {
        /// This function will log in the retailer with their username & password.  This should go & fetch the clientId & clientSecret for that retailer account.
        @objc public static func logInWith(password: String, username: String, _ completion: @escaping (_ success: Bool, _ error: Error?)->Void) {
            
            
        }
    }
    
    @objc public class Transaction : NSObject {
        
        /// This is the primary key for the transaction table.
        @objc public dynamic var bucketTransactionId : String?
        @objc public dynamic var customerCode : String?
        /// This is the URL for the qr code, in order for the user to redeem their bucket change.
        @objc dynamic var qrCodeContent : URL?
        /// This is defined by the retailer.  This is used if the retailer has multiple locations for their retailer account.
        @objc public dynamic var locationId : String?
        /// This is the hardware id of the POS terminal or device.
        @objc public dynamic var terminalId : String?
        
        /// This returns the amount for the transaction in an integer form.  1000 would be $10.00
        @objc public dynamic var amount : Int
        /// This returns the client transaction id, that being the id for the order or sale.
        @objc public dynamic var clientTransactionId : String
        /// This is associated with the day that the store has created the transaction.
        @objc public dynamic var intervalId : String!
        
        @objc public init(amount : Int, clientTransactionId : String) {
            self.amount = amount
            self.clientTransactionId = clientTransactionId
            // Now lets set the terminalId - otherwise known as the unique identifier for the hardware.
            if let uuid = UIDevice.current.identifierForVendor { self.terminalId = uuid.uuidString }
            
        }
        
        private var toJSON : [String:Any] {
            var json : [String:Any] = .init()
            
            // Take care of all the values that we would always send:
            self.intervalId = Date.now.toYYYYMMDD
            json["amount"] = self.amount
            json["clientTransactionId"] = self.clientTransactionId
            json["intervalId"] = self.intervalId
            
            if (!self.locationId.isNil) { json["locationId"] = self.locationId! }
            if (!self.customerCode.isNil) { json["customerCode"] = self.customerCode! }
            if (!self.terminalId.isNil) { json["terminalId"] = self.terminalId! }
            
            return json
        }
        
        @objc public func create(_ completion: @escaping (_ success : Bool, _ error: Error?)->Void) {
            var url = URL.Transaction.base
            url.appendPathComponent("transaction")
            if let clientId = Bucket.Credentials.clientId, let secret = Bucket.Credentials.clientSecret {
                url.appendPathComponent(clientId)
                url.addQueryParams(["code": secret])
                // Send the request:
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if response.isSuccess {
                        // Return the completion as successful:
                        completion(response.isSuccess, error)
                    } else if let bucketError = data?.bucketError {
                        completion(response.isSuccess, bucketError)
                    }  else {
                        completion(response.isSuccess, error)
                    }
                    
                }.resume()
            } else {
                // Call back & let the user know we dont have a client id to create this transaction:
                completion(false, BucketError.invalidCredentials)
            }
        }
    }
    
    @objc public class Credentials : NSObject {
        @objc public  private(set) static var clientId : String? {
            get {
                return Bucket.shared.keychain.get("BUCKETID")
            }
            set {
                // Implement the setter:
                if newValue.isNil {
                    Bucket.shared.keychain.delete("BUCKETID")
                } else {
                    Bucket.shared.keychain.set(newValue!, forKey: "BUCKETID")
                }
            }
        }
        @objc public private(set) static var clientSecret : String? {
            get {
                return Bucket.shared.keychain.get("BUCKETSECRET")
            }
            set {
                // Implement the setter:
                if newValue.isNil {
                    Bucket.shared.keychain.delete("BUCKETSECRET")
                } else {
                    Bucket.shared.keychain.set(newValue!, forKey: "BUCKETSECRET")
                }
            }
        }
    }
    
}

//MARK: - Bucket Extensions
public extension Optional {
    public var isNil : Bool { return self == nil }
}
@objc public extension DateFormatter {
    public convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
public extension UserDefaults {
    internal var denominations : [Int]? {
        get {
            return self.array(forKey: "BUCKET_RETAILER_DENOMS") as? [Int]
        }
        set {
            self.set(newValue, forKey: "BUCKET_RETAILER_DENOMS")
        }
    }
}

extension URL {
    struct Retail {
        static var base : URL {
            switch Bucket.shared.environment {
            case .Production:
                return URL(string: "https://bucketthechange.com/api")!
            case .Development:
                return URL(string: "https://sandboxretailerapi.bucketthechange.com/api")!
            }
        }
    }
    struct Transaction {
        static var base : URL {
            switch Bucket.shared.environment {
            case .Production:
                return URL(string: "https://bucketthechange.com/api")!
            case .Development:
                return URL(string: "https://sandboxretailerapi.bucketthechange.com/api")!
            }
        }
    }
    
    /// Add query parameters to your URL object using a dictionary.
    public mutating func addQueryParams(_ queryParams : [String:Any]) {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        // Start putting together the paths:
        for param in queryParams {
            // If the query items is nil, we need to initialize so we can actually add the items:
            if components?.queryItems.isNil  == true {
                components?.queryItems = []
            }
            let queryItem = URLQueryItem(name: param.key, value: String(describing: param.value))
            components?.queryItems?.append(queryItem)
        }
        
        if let url = components?.url  {
            self = url
        }
    }
}

class BucketError: Error {}

public extension Error {
    static var invalidCredentials : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Please check Retailer Id and Secret Code."]) }
    static var verificationError : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Account requires verification or verification has lapsed. Please contact Bucket support."]) }
    static var zeroTransaction : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Non-zero amount required."]) }
    static var noIntervalId : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "This interval id has been previously closed."]) }
    static var unknown : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unknown issue.  Please try again later."]) }
}

public extension Data {
    var asJSON : [String:Any]? {
        if let theTry = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String:Any] {
            return theTry
        } else {
            return nil
        }
    }
    var bucketError : Error? {
        if let json = self.asJSON {
            if !json["errorCode"].isNil {
                if let message = json["message"] as? String {
                    return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: message])
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
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

public extension Optional where Wrapped == URLResponse {
    var isSuccess : Bool {
        if self.isNil { return false }
        switch self!.code {
        case 200...299:
            return true
        default:
            return false
        }
    }
}

@objc public extension URLResponse {
    @objc var code : Int {
        return (self as! HTTPURLResponse).statusCode
    }
}

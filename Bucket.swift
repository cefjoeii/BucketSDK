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
    private override init() {
        super.init()
        /// Make sure our interval ids are using the UTC datestamp:
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    
    /// This is our date formatter for sending the interval ids.
    fileprivate var dateFormatter : DateFormatter = DateFormatter(format: "yyyyMMdd")
    
    /// This is the denominations of the dollar bills in the register for this retailer:
    @objc public dynamic var denominations : [Int] {
        get {
            return UserDefaults.standard.denominations ?? [10000, 5000, 2000, 1000, 500, 200, 100]
        }
        set {
            UserDefaults.standard.denominations = newValue
        }
    }
    private var keychain : KeychainSwift = KeychainSwift()
    
    /// This is the environment that defines which endpoint we will hit for either sandbox or the production endpoint.
    @objc public dynamic var environment : DeploymentEnvironment = .Development
    
    private var useNaturalChangeFunction : Bool {
        get {
            return UserDefaults.standard.object(forKey: "usesNaturalChangeFunction") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "usesNaturalChangeFunction")
        }
    }
    
    /// This function returns the bucket amount based on the dollar & change amount.
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
    
    // This function will close the specified interval.  This initiates an ACH bank transfer from the retailer to Bucket.
    @objc public func close(interval: String, _ completion: ((_ success: Bool, _ error: Error?)->Void)?=nil) {
        
        guard let clientSecret = Bucket.Credentials.retailerSecret, let clientId = Bucket.Credentials.retailerId else {
            completion?(false, BucketError.invalidCredentials)
            return
        }
        
        // Okay - they have their client id & client secret.  Lets make the request:
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
    
    /// This function fetches the bill denominations for the retailer and caches them for the Bucket class.
    @objc public func fetchBillDenominations(_ CurrencyCode : BillDenomination, completion: @escaping (_ success: Bool, _ error : Error?)->Void) {
        
        // This is just the URL for the bill denominations.  This does not change between dev & production.
        let url = URL.Retail.billDenominations
        // We default to USD:
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if response.isSuccess {
                // We successfully logged in, we should go & check for the denominations & returned:
                if let json = data?.asJSON {
                    // We have an array of the currencies based on the currency code, lets grab the correct currency code:
                    if let currencies = json["currencies"] as? [[String:Any]] {
                        
                        for currency in currencies {
                            // Get the currency code:
                            let currencyCode = currency["currencyCode"].stringValue
                            // If it is not the correct one, lets continue looping:
                            if currencyCode != CurrencyCode.stringValue { continue }
                            
                            // Finish processing if it is the correct code:
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
            completion(false, NSError(domain: "none", code: 400, userInfo: [NSLocalizedDescriptionKey:"Retailer login is not supported just yet."]))
        }
    }
    
    @objc public class Transaction : NSObject {
        
        /// This is the primary key for the transaction table.
        @objc public dynamic var bucketTransactionId : String?
        @objc public dynamic var customerCode : String?
        /// This is the URL for the qr code, in order for the user to redeem their bucket change.
        @objc public dynamic var qrCodeContent : URL?
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
        
        /// You will need to initialize a transaction with an amount, and a transaction/order/sale id.
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
                    // First we need to update the transaction object with the json data:
                    self.updateWith(data?.asJSON)
                    // Return the completion as successful:
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
        /// This is the client id of the retailer.  This is used to authorize requests with Bucket.
        @objc public  /*private(set)*/ static var retailerId : String? {
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
        /// This is the client secret of the retailer.  This is used to authorize requests with Bucket.
        @objc public  /*private(set)*/ static var retailerSecret : String? {
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
    /// This checks the value of the object, returning true or false if the value is nil or not.
    public var isNil : Bool { return self == nil }
    
    public var stringValue : String? {
        if self.isNil { return nil }
        switch self {
        case is String, is String?:
            return self as? String
        default:
            return nil
        }
    }
    public var urlValue : URL? {
        if self.isNil { return nil }
        switch self {
        case is String, is String?:
            return URL(string: self as! String)
        default:
            return nil
        }
    }
    public var intValue : Int? {
        if self.isNil { return nil }
        switch self {
        case is Int, is Int?:
            return self as? Int
        default:
            return nil
        }
    }
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
        static var billDenominations : URL {
            return URL(string: "https://bucketresources.blob.core.windows.net/static/Currencies.json")!
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
    struct close {
        static var interval : URL {
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

class BucketError: Error { private init() {} }

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

extension Dictionary {
    var data : Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    var prettyPrint : String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            // Now lets cast this back into a string:
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

enum HTTPMethod: String {
    case post = "POST", put = "PUT", delete = "DELETE", get = "GET"
}
extension URLRequest {
    mutating func setMethod(_ method: HTTPMethod) {
        self.httpMethod = method.rawValue
    }
    mutating func setJSONBody(_ json : [String:Any]) {
        self.httpBody = json.data
    }
}


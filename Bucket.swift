//
//  Bucket.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

@objc public class Bucket: NSObject {
    @objc public static let shared = Bucket()
    private override init() { super.init() }
    
    /// This is our date formatter for sending the interval ids.
    private var dateFormatter : DateFormatter = DateFormatter(format: "yyyyMMdd")
    /// This is the denominations of the dollar bills in the register for this retailer:
    private var denominations : [Int] {
        return UserDefaults.standard.denominations ?? [10000, 5000, 2000, 1000, 500, 200]
    }
    
    @objc public var environment : DeploymentEnvironment = .Production
    
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
        
        let request = URLRequest(url: URL(string: "https://example.com")!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if response.isSuccess {
                // We successfully logged in, we should go & check for the denominations & returned:
                if let json = data?.asJSON {
                    UserDefaults.standard.denominations = json["denominations"] as? [Int]
                }
                // Return the completion:
                completion(response.isSuccess, error)
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
        
        
        @objc public dynamic var locationId : String?
        @objc public dynamic var terminalId : String?
        
        /// This returns the amount for the transaction in an integer form.  1000 would be $10.00
        @objc public dynamic var amount : Int
        /// This returns the client transaction id, that being the id for the order or sale.
        @objc public dynamic var clientTransactionId : String
        /// This is associated with the day that the store has created the transaction.
        @objc public dynamic var intervalId : String
        
        @objc public init(amount : Int, clientTransactionId : String) {
            self.amount = amount
            self.clientTransactionId = clientTransactionId
            self.intervalId = Bucket.shared.dateFormatter.string(from: Date())
        }
        
        private var toJSON : [String:Any] {
            var json : [String:Any] = .init()
            json["amount"] = self.amount
            json["clientTransactionId"] = self.clientTransactionId
            json["intervalId"] = self.intervalId
            
            return json
        }
        
        public func create(_ completion: @escaping (_ success : Bool, _ error: Error?)->Void) {
            
        }
    }
    
    @objc public class Credentials : NSObject {
        @objc public static var clientId : String? {
            get {
                return nil
            }
            set {
                // Implement the setter:
            }
        }
        @objc public static var clientSecret : String? {
            get {
                return nil
            }
            set {
                // Implement the setter:
            }
        }
    }
    
}

//MARK: - Bucket Extensions
public extension Optional where Wrapped == Any {
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

public extension Data {
    var asJSON : [String:Any]? {
        if let theTry = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String:Any] {
            return theTry
        } else {
            return nil
        }
    }
}

public extension Optional where Wrapped == URLResponse {
    var isSuccess : Bool {
        if self == nil { return false }
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

//
//  Transaction.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/16/18.
//

import Foundation

@objc public enum TrannsactionType: Int {
    case regular, event
    
    var stringValue: String {
        switch self {
        case .regular:
            return "regular"
        case .event:
            return "event"
        }
    }
}

@objc public class Transaction: NSObject {
    // MARK: - Header ============================================================
    /// This is the four digit code assigned to the employee.
    /// This only required when the retailer turns on employee codes.
    @objc public dynamic var employeeId: String?
    
    /// This is the eventId.
    /// Please make sure to create an event and use that id here if you want to associate the transaction with an event.
    @objc public dynamic var eventId: Int = -1
    
    // MARK: - Body ============================================================
    /// This is the currency described in decimal. This is a required field.
    @objc public dynamic var amount: Double = 0
    
    /// The entire amount with tax, for the items purchased at the point of the sale. Represented in decimal.
    @objc public dynamic var totalTransactionAmount: Double = 0
    
    /// Retailer-defined unique identifier for the location of the device.
    @objc public dynamic var locationId: String?
    
    /// The retailer-defined unique id of the transaction.
    /// Example: Use the internal id to the POS to relate back to the bucket defined unique id.
    @objc public dynamic var clientTransactionId: String?
    
    /// If this is passed in, only sample users can redeem this code.
    @objc public dynamic var sample: Bool = false
    
    /// This is the event name for the current event Bucket is hosting.
    /// They will need to change this if they would go to another event.
    @objc public dynamic var eventName: String?
    
    /// This is the event message for the current event Bucket is hosting.
    /// They will need to change this if they would go to another event.
    @objc public dynamic var eventMessage: String?
    
    // MARK: API Response ============================================================
    /// This is the code associated with the transaction. This gives the customer a way to redeem their change!
    @objc public dynamic var customerCode: String?
    
    /// This is the URL that will redirect the user to Bucket's website & redeem to their account.
    private var qrCodeContent: String?
    
    @objc public dynamic var qrCode: UIImage?
    
    /// Bucket-generated unique identifier for this transaction.
    @objc public dynamic var bucketTransactionId: Int = -1
    
    @objc public init(
        amount: Double,
        totalTransactionAmount: Double = 0,
        // locationId: String? = nil,
        clientTransactionId: String? = nil,
        // sample: Bool = false,
        // eventName: String? = "",
        // eventMessage: String? = "",
        employeeId: String? = nil //,
        // eventId: String? = nil
        ) {
        
        self.amount = amount
        self.totalTransactionAmount = totalTransactionAmount
        // self.locationId = locationId
        self.clientTransactionId = clientTransactionId
        // self.sample = sample
        // self.eventName = eventName
        // self.eventMessage = eventMessage
        self.employeeId = employeeId
        // self.eventId = eventId
    }
    
    @objc public init(customerCode: String) {
        self.customerCode = customerCode
    }

    /// Allows a POS integration developer add a transaction.
    @objc public func create(transactionType: TrannsactionType, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let retailerId = Bucket.Credentials.retailerCode, let terminalSecret = Bucket.Credentials.terminalSecret else {
            completion(false, BucketError.invalidRetailer)
            return
        }
        
        guard let terminalId = Bucket.Credentials.terminalId else {
            completion(false, BucketError.noTerminalId)
            return
        }
        
        guard let countryCode = Bucket.Credentials.retailerInfo?.countryCode else {
            completion(false, BucketError.invalidCountryCode)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction")
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.addHeader("retailerId", retailerId)
        request.addHeader("terminalId", terminalId)
        request.addHeader("countryId", countryCode)
        if let employeeId = self.employeeId { request.addHeader("employeeId", employeeId) }
        if self.eventId != -1 { request.addHeader("eventId", String(self.eventId)) }
        request.addHeader("x-functions-key", terminalSecret)
        
        // Prepare for a JSON body request param
        var params: [String: Any] {
            var json = [String: Any]()
            
            switch transactionType {
            case .regular:
                json["amount"] = self.amount
                if self.totalTransactionAmount != 0 { json["totalTransactionAmount"] = self.totalTransactionAmount }
                if let locationId = self.locationId { json["locationId"] = locationId }
                if let clientTransactionId = self.clientTransactionId { json["clientTransactionId"] = clientTransactionId }
                json["sample"] = self.sample
                return json
            case .event:
                json["amount"] = self.amount
                json["eventName"] = self.eventName
                json["eventMessage"] = self.eventMessage
                return json
            }
        }
        
        request.setBody(params)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {completion(false, error); return }
            
            if response.isSuccess {
                self.update(with: data.asJSON)
                completion(true, nil)
            } else {
                let bucketError = try? JSONDecoder().decode(BucketError.self, from: data)
                completion(false, bucketError?.asError(response?.code) ?? BucketError.unknown)
            }
            }.resume()
    }
    
    /// Allows POS integration developer delete a transaction that has not been redeemed by a user in Bucket's system.
    @objc public func delete(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let retailerId = Bucket.Credentials.retailerCode, let terminalSecret = Bucket.Credentials.terminalSecret else {
            completion(false, BucketError.invalidRetailer)
            return
        }
        
        guard let terminalId = Bucket.Credentials.terminalId else {
            completion(false, BucketError.noTerminalId)
            return
        }
        
        guard let countryCode = Bucket.Credentials.retailerInfo?.countryCode else {
            completion(false, BucketError.invalidCountryCode)
            return
        }
        
        guard let customerCode = self.customerCode else {
            completion(false, BucketError.invalidCode)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction").appendingPathComponent(customerCode)
        var request = URLRequest(url: url)
        request.setMethod(.delete)
        request.addHeader("retailerId", retailerId)
        request.addHeader("terminalId", terminalId)
        request.addHeader("countryId", countryCode)
        request.addHeader("x-functions-key", terminalSecret)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, error); return }
            
            if response.isSuccess {
                completion(true, nil)
            } else {
                let bucketError = try? JSONDecoder().decode(BucketError.self, from: data)
                completion(false, bucketError?.asError(response?.code) ?? BucketError.unknown)
            }
            }.resume()
    }
    
    private func update(with json: [String: Any]?) {
        if let json = json {
            self.customerCode = json["customerCode"] as? String
            self.qrCodeContent = json["qrCodeContent"] as? String
            self.qrCode = qrCodeContent?.asQrCode
            if let bucketTransactionId = json["bucketTransactionId"] as? Int { self.bucketTransactionId = bucketTransactionId }
            self.amount = json["amount"] as? Double ?? self.amount
            self.locationId = json["locationId"] as? String
            self.clientTransactionId = json["clientTransactionId"] as? String
        }
    }
}

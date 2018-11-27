//
//  CreateTransactionRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/16/18.
//

import Foundation

@objc public class CreateTransactionRequest: NSObject {
    // MARK: - Headers
    /// The four digit code assigned to the employee. **This only required when the retailer turns on employee codes.**
    @objc public dynamic var employeeCode: String?
    
    /// Please make sure to create an event and use that id here if you want to associate the transaction with an event.
    @objc public dynamic var eventId: String?
    
    // MARK: - Body
    /// The currency described in decimal. This is a required field.
    @objc public dynamic var amount: Double
    
    /// The entire amount with tax, for the items purchased at the point of the sale. Represented in decimal.
    @objc public dynamic var totalTransactionAmount: Double = 0
    
    /// Retailer-defined unique identifier for the location of the device.
    @objc public dynamic var locationId: String?
    
    /// The retailer-defined unique id of the transaction.
    /// Example: Use the internal id to the POS to relate back to the bucket defined unique id.
    @objc public dynamic var clientTransactionId: String?
    
    /// If this is passed in, only sample users can redeem this code.
    @objc public dynamic var sample: Bool = false
    
    /// - Parameter amount: The currency described in decimal. This is a required field.
    @objc public init(amount: Double) {
        self.amount = amount
    }
    
    var body: [String: Any] {
        var json = [String: Any]()
        json["amount"] = self.amount
        if self.totalTransactionAmount != 0 { json["totalTransactionAmount"] = self.totalTransactionAmount }
        if let locationId = self.locationId { json["locationId"] = locationId }
        if let clientTransactionId = self.clientTransactionId { json["clientTransactionId"] = clientTransactionId }
        json["sample"] = self.sample
        
        return json
    }
}

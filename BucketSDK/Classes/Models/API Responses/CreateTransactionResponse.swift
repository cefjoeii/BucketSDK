//
//  CreateTransactionResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/21/18.
//

import Foundation

@objc public class CreateTransactionResponse: NSObject, Decodable {
    /// This is the code associated with the transaction.  This gives the customer a way to redeem their change!
    @objc public let customerCode: String?
    
    /// This is the URL that will redirect the user to Bucket's website & redeem to their account.
    let qrCodeContent: URL?
    
    /// Bucket-generated unique identifier for this transaction.
    @objc public let bucketTransactionId: String?
    
    /// This is the currency described in decimal.
    @objc public var amount: Int = 0
    
    /// Retailer-defined unique identifier for the location of the device.
    @objc public var totalTransactionAmount: Int = 0
    
    // This is defined by the retailer.  This is used if the retailer has multiple locations for their retailer account.
    @objc public let locationId: String?
    
    // This returns the client transaction id, that being the id for the order or sale.
    @objc public let clientTransactionId: String?
    
    // This is the hardware id of the POS terminal or device.
    @objc public let terminalId: String?
    
    /* init(json: [String: Any]) {
        customerCode = json["customerCode"] as? String
        qrCodeContent = json["qrCodeContent"] as? URL
        bucketTransactionId = json["bucketTransactionId"] as? String
        amount = json["amount"] as? Int ?? 0
        totalTransactionAmount = json["totalTransactionAmount"] as? Int ?? 0
        intervalId = json["intervalId"] as? String
        locationId = json["locationId"] as? String
        clientTransactionId = json["clientTransactionId"] as? String
        terminalId = json["terminalId"] as? String
    } */
}

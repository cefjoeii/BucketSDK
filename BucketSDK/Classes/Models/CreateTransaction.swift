//
//  CreateTransaction.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/21/18.
//

import Foundation

@objc public class CreateTransactionResponse: NSObject, Decodable {
    
    @objc public let customerCode: String?
    
    // This is the URL for the qr code, in order for the user to redeem their bucket change.
    @objc public let qrCodeContent: URL?
    
    // This is the primary key for the transaction table.
    @objc public let bucketTransactionId: String?
    
    // This returns the amount for the transaction in an integer form.  1000 would be $10.00
    @objc public var amount: Int = 0
    
    @objc public var totalTransactionAmount: Int = 0
    
    // This is associated with the day that the store has created the transaction.
    @objc public let intervalId: String?
    
    // This is defined by the retailer.  This is used if the retailer has multiple locations for their retailer account.
    @objc public let locationId: String?
    
    // This returns the client transaction id, that being the id for the order or sale.
    @objc public let clientTransactionId: String?
    
    // This is the hardware id of the POS terminal or device.
    @objc public let terminalId: String?
    
    init(json: [String: Any]) {
        customerCode = json["customerCode"] as? String
        qrCodeContent = json["qrCodeContent"] as? URL
        bucketTransactionId = json["bucketTransactionId"] as? String
        amount = json["amount"] as? Int ?? 0
        totalTransactionAmount = json["totalTransactionAmount"] as? Int ?? 0
        intervalId = json["intervalId"] as? String
        locationId = json["locationId"] as? String
        clientTransactionId = json["clientTransactionId"] as? String
        terminalId = json["terminalId"] as? String
    }
}

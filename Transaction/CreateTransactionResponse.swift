//
//  CreateTransactionResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/21/18.
//

import Foundation

@objc public class CreateTransactionResponse: NSObject {
    /// The code associated with the transaction. This gives the customer a way to redeem their change.
    @objc public let customerCode: String?
    
    /// The URL that will redirect the user to Bucket's website and redeem to their account.
    private let qrCodeContent: String?
    
    /// The generated image from the redeem URL.
    @objc public let qrCode: UIImage?
    
    /// Bucket-generated unique identifier for this transaction.
    @objc public let bucketTransactionId: Int
    
    /// The currency described in decimal.
    @objc public let amount: Double
    
    /// The retailer-defined unique identifier for the location of the device.
    @objc public let locationId: String?
    
    /// The retailer-defined unique id of the transaction.
    /// - Example: Use the internal id to the POS to relate back to the bucket defined unique id.
    @objc public let clientTransactionId: String?
    
    init(json: [String: Any]?) {
        self.customerCode = json?["customerCode"] as? String
        self.qrCodeContent = json?["qrCodeContent"] as? String
        self.qrCode = self.qrCodeContent?.asQrCode
        self.bucketTransactionId = json?["bucketTransactionId"] as? Int ?? -1
        self.amount = json?["amount"] as? Double ?? 0
        self.locationId = json?["locationId"] as? String
        self.clientTransactionId = json?["clientTransactionId"] as? String
    }
}

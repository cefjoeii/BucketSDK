//
//  GetReportsResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/20/18.
//

@objc public class GetReportsResponse: NSObject, Decodable {
    @objc public let bucketTotal: Double
    @objc public let transactions: [ReportTransaction]?
    
    init(json: [String: Any]) {
        self.bucketTotal = json["bucketTotal"] as? Double ?? 0
        self.transactions = json["transactions"] as? [ReportTransaction]
    }
}

@objc public class ReportTransaction: NSObject, Decodable {
    @objc public let bucketTransactionId: Int
    @objc public let created: String?
    @objc public let amount: Double
    @objc public let totalTransactionAmount: Double
    @objc public let customerCode: String?
    @objc public let disputed: String?
    @objc public let disputedBy: String?
    @objc public let locationId: String?
    @objc public let clientTransactionid: String?
    @objc public let terminalId: Int
    
    init(json: [String: Any]) {
        self.bucketTransactionId = json["bucketTransactionId"] as? Int ?? -1
        self.created = json["created"] as? String
        self.amount = json["amount"] as? Double ?? 0
        self.totalTransactionAmount = json["totalTransactionAmount"] as? Double ?? 0
        self.customerCode = json["customerCode"] as? String
        self.disputed = json["disputed"] as? String
        self.disputedBy = json["disputedBy"] as? String
        self.locationId = json["locationId"] as? String
        self.clientTransactionid = json["clientTransactionId"] as? String
        self.terminalId = json["terminalId"] as? Int ?? -1
    }
}

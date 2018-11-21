//
//  FetchReportsResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/20/18.
//

@objc public class FetchReportsResponse: NSObject, Decodable {
    @objc public let bucketTotal: Double = 0
    @objc public let transactions: [ReportTransaction]?
}

@objc public class ReportTransaction: NSObject, Decodable {
    @objc public let bucketTransactionId: Int = -1
    @objc public let created: String?
    @objc public let amount: Double = 0
    @objc public let totalTransactionAmount: Double = 0
    @objc public let customerCode: String?
    @objc public let disputed: String?
    @objc public let disputedBy: String?
    @objc public let locationId: String?
    @objc public let clientTransactionid: String?
    @objc public let terminalId: Int = -1
}

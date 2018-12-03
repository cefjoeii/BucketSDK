//
//  GetEventsReportResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/29/18.
//

import Foundation

@objc public class GetEventsReportResponse: NSObject, Decodable {
    @objc public let events: [EventReport]?
}

@objc public class EventReport: NSObject, Decodable {
    @objc public let id: Int
    
    @objc public let eventName: String?
    
    @objc public let eventMessage: String?
    
    /// This is UTC date format of 'yyyy-MM-dd HH:mm:ss'
    @objc public let startDate: String?
    
    /// This is UTC date format of 'yyyy-MM-dd HH:mm:ss'
    @objc public let endDate: String?
    
    
    @objc public let bucketTotal: Double
    
    /// This is the summed up value for the totalTransactionAmount across the entire query.
    /// The transactions array is paged. This value is NOT.
    @objc public let bucketSales: Double
    
    /// This will be the refunded bucketed total for the entire paging of the report,
    /// if the transaction has been reported as refunded.
    @objc public let refundedBucketTotal: Double
    
    /// This is the summed up value for the totalTransactionAmount across the entire query,
    // if the transaction was REFUNDED. The transactions array is paged. This value is NOT.
    @objc public let refundedBucketSales: Double
    
    @objc public let transactions: [ReportTransaction]?
    
    private enum CodingKeys: String, CodingKey {
        case id, eventName, eventMessage, startDate, endDate, bucketTotal,
        bucketSales, refundedBucketTotal, refundedBucketSales, transactions
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.eventName = try container.decodeIfPresent(String.self, forKey: .eventName)
        self.eventMessage = try container.decodeIfPresent(String.self, forKey: .eventMessage)
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.bucketTotal = try container.decodeIfPresent(Double.self, forKey: .bucketTotal) ?? 0
        self.bucketSales = try container.decodeIfPresent(Double.self, forKey: .bucketSales) ?? 0
        self.refundedBucketTotal = try container.decodeIfPresent(Double.self, forKey: .refundedBucketTotal) ?? 0
        self.refundedBucketSales = try container.decodeIfPresent(Double.self, forKey: .refundedBucketSales) ?? 0
        self.transactions = try container.decodeIfPresent([ReportTransaction].self, forKey: .transactions)
    }
}

//
//  GetReportsResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/20/18.
//

@objc public class GetReportsResponse: NSObject, Decodable {
    /// The count of the transactions against the entire query.
    /// This would give you a good indication if you need to page the transactions.
    @objc public let totalTransactionCount: Int
    
    /// This will be the bucketed total for the entire paging of the report.
    @objc public let bucketTotal: Double
    
    /// The summed up value for the totalTransactionAmount across the entire query.
    /// The transactions array is paged. This value is NOT.
    @objc public let bucketSales: Double
    
    /// This will be the refunded bucketed total for the entire paging of the report,
    /// if the transaction has been reported as refunded.
    @objc public let refundedBucketTotal: Double
    
    /// The summed up value for the totalTransactionAmount across the entire query,
    /// if the transaction was REFUNDED. The transactions array is paged. This value is NOT.
    @objc public let refundedBucketSales: Double
    
    /// The transactions are paged. If the report exceeds the limit amount,
    /// then you will have to offset to read the rest of the report.
    @objc public let transactions: [ReportTransaction]?
    
    private enum CodingKeys: String, CodingKey {
        case totalTransactionCount, bucketTotal, bucketSales, refundedBucketTotal, refundedBucketSales, transactions
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalTransactionCount = try container.decodeIfPresent(Int.self, forKey: .totalTransactionCount) ?? 0
        self.bucketTotal = try container.decodeIfPresent(Double.self, forKey: .bucketTotal) ?? 0
        self.bucketSales = try container.decodeIfPresent(Double.self, forKey: .bucketSales) ?? 0
        self.refundedBucketTotal = try container.decodeIfPresent(Double.self, forKey: .refundedBucketTotal) ?? 0
        self.refundedBucketSales = try container.decodeIfPresent(Double.self, forKey: .refundedBucketSales) ?? 0
        self.transactions = try container.decodeIfPresent([ReportTransaction].self, forKey: .transactions)
    }
}

@objc public class ReportTransaction: NSObject, Decodable {
    /// This is the id for the bucket transaction.
    @objc public let bucketTransactionId: Int
    
    @objc public let created: String?
    
    /// The currency described in decimal. This is a required field.
    @objc public let amount: Double
    
    /// The entire amount with tax, for the items purchased at the point of the sale. Represented in decimal.
    @objc public let totalTransactionAmount: Double
    
    @objc public let customerCode: String?
    
    /// The date at which someone reported a dispute for this transaction.
    @objc public let disputed: String?
    
    /// The id of the user that disputed the transaction.
    @objc public let disputedBy: String?
    
    /// The date at which the retailer claimed to refund this transaction.
    @objc public let refunded: String?
    
    /// The id of the user that refunded the transaction.
    @objc public let refundedBy: String?
    
    /// Retailer-defined unique identifier for the location of the device.
    @objc public let locationId: String?
    
    /// The retailer-defined unique id of the transaction.
    /// - Example: Use the internal id to the POS to relate back to the bucket defined unique id.
    @objc public let clientTransactionid: String?
    
    /// The terminal that created the transaction.
    @objc public let terminalCode: String?
    
    /// The id of the employee.
    @objc public let employeeId: Int
    
    private enum CodingKeys: String, CodingKey {
        case bucketTransactionId, created, amount, totalTransactionAmount, customerCode,
        disputed, disputedBy, refunded, refundedBy, locationId, clientTransactionid,
        terminalCode, employeeId
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bucketTransactionId = try container.decodeIfPresent(Int.self, forKey: .bucketTransactionId) ?? -1
        self.created = try container.decodeIfPresent(String.self, forKey: .created)
        self.amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0
        self.totalTransactionAmount = try container.decodeIfPresent(Double.self, forKey: .totalTransactionAmount) ?? 0
        self.customerCode = try container.decodeIfPresent(String.self, forKey: .customerCode)
        self.disputed = try container.decodeIfPresent(String.self, forKey: .disputed)
        self.disputedBy = try container.decodeIfPresent(String.self, forKey: .disputed)
        self.refunded = try container.decodeIfPresent(String.self, forKey: .refunded)
        self.refundedBy = try container.decodeIfPresent(String.self, forKey: .refundedBy)
        self.locationId = try container.decodeIfPresent(String.self, forKey: .locationId)
        self.clientTransactionid = try container.decodeIfPresent(String.self, forKey: .clientTransactionid)
        self.terminalCode = try container.decodeIfPresent(String.self, forKey: .terminalCode)
        self.employeeId = try container.decodeIfPresent(Int.self, forKey: .employeeId) ?? -1
    }
}

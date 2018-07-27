//
//  CloseInterval.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/21/18.
//

import Foundation

@objc public class CloseIntervalResponse: NSObject, Decodable {

    public let intervalId: String?
    public let intervalAmount: Int?
    public let transactions: [CloseIntervalTransaction]?
    
    init(json: [String: Any]) {
        intervalId = json["intervalId"] as? String
        intervalAmount = json["intervalAmount"] as? Int
        transactions = json["transactions"] as? [CloseIntervalTransaction]
    }
    
    @objc public class CloseIntervalTransaction: NSObject, Decodable {
        public let amount: Int?
        public let totalTransactionAmount: Int?
        public let intervalId: String?
        public let locationId: String?
        public let clientTransactionId: String?
        public let terminalId: String?
        public let bucketTransactionId: String?
        
        init(json: [String: Any]) {
            amount = json["amount"] as? Int
            totalTransactionAmount = json["totalTransactionAmount"] as? Int
            intervalId = json["intervalId"] as? String
            locationId = json["locationId"] as? String
            clientTransactionId = json["clientTransactionId"] as? String
            terminalId = json["terminalId"] as? String
            bucketTransactionId = json["bucketTransactionId"] as? String
        }
    }
}

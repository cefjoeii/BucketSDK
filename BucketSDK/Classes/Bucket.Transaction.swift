//
//  Bucket.Transaction.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/23/18.
//

import Foundation

extension Bucket {
    /// Allows a POS integration developer add a transaction.
    @objc public func createTransaction(
        _ transactionRequest: TransactionRequest,
        completion: @escaping (_ success: Bool, _ response: CreateTransactionResponse?, _ error: Error?) -> Void
        ) {
        
        // Return and tell the developer that the employee code is required.
        if Credentials.requireEmployeeCode && transactionRequest.employeeCode.isNil {
            completion(false, nil, BucketErrorResponse.invalidEmployeeCode)
            return
        }
        
        guard let retailerCode = Credentials.retailerCode, let terminalSecret = Credentials.terminalSecret else {
            completion(false, nil, BucketErrorResponse.invalidRetailer)
            return
        }
        
        guard let terminalCode = Credentials.terminalCode else {
            completion(false, nil, BucketErrorResponse.noTerminalId)
            return
        }
        
        guard let country = Credentials.retailerInfo?.country else {
            completion(false, nil, BucketErrorResponse.invalidCountryCode)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction")
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.addHeader("retailerCode", retailerCode)
        request.addHeader("terminalCode", terminalCode)
        request.addHeader("country", country)
        request.addHeader("x-functions-key", terminalSecret)
        if let employeeCode = transactionRequest.employeeCode { request.addHeader("employeeCode", employeeCode) }
        if let eventId = transactionRequest.eventId { request.addHeader("eventId", eventId) }
        request.setBody(transactionRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {completion(false, nil, error); return }
            
            if response.isSuccess {
                let createTransactionResponse = CreateTransactionResponse(json: data.asJSON)
                completion(true, createTransactionResponse, nil)
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, nil, bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
    
    /// Allows POS integration developer to refund a transaction that has not been redeemed by a user in Bucket's system.
    @objc public func refundTransaction(customerCode: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        self.updateTransaction(customerCode: customerCode, method: .patch, completion: completion)
    }
    
    /// Allows POS integration developer delete a transaction that has not been redeemed by a user in Bucket's system.
    @objc public func deleteTransaction(customerCode: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        self.updateTransaction(customerCode: customerCode, method: .delete, completion: completion)
    }
    
    private func updateTransaction(customerCode: String, method: HTTPMethod, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let retailerCode = Credentials.retailerCode, let terminalSecret = Credentials.terminalSecret else {
            completion(false, BucketErrorResponse.invalidRetailer)
            return
        }
        
        guard let terminalCode = Credentials.terminalCode else {
            completion(false, BucketErrorResponse.noTerminalId)
            return
        }
        
        guard let country = Credentials.retailerInfo?.country else {
            completion(false, BucketErrorResponse.invalidCountryCode)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction").appendingPathComponent(customerCode)
        var request = URLRequest(url: url)
        request.setMethod(method)
        request.addHeader("retailerCode", retailerCode)
        request.addHeader("terminalCode", terminalCode)
        request.addHeader("country", country)
        request.addHeader("x-functions-key", terminalSecret)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, error); return }
            
            if response.isSuccess {
                completion(true, nil)
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
}

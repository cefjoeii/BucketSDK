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
        _ createTransactionRequest: CreateTransactionRequest,
        completion: @escaping (_ success: Bool, _ response: CreateTransactionResponse?, _ error: Error?) -> Void
        ) {
        
        // Return and tell the developer that the employee code is required.
        if Credentials.requireEmployeeCode && createTransactionRequest.employeeCode.isNil {
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
        if let employeeCode = createTransactionRequest.employeeCode { request.addHeader("employeeCode", employeeCode) }
        if let eventId = createTransactionRequest.eventId { request.addHeader("eventId", eventId) }
        request.setBody(createTransactionRequest.body)
        
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
    @objc public func refundTransaction(
        customerCode: String,
        completion: @escaping (_ success: Bool, _ response: RefundTransactionResponse?, _ error: Error?) -> Void
        ) {
        
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
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction").appendingPathComponent(customerCode)
        var request = URLRequest(url: url)
        request.setMethod(.patch)
        request.addHeader("retailerCode", retailerCode)
        request.addHeader("terminalCode", terminalCode)
        request.addHeader("country", country)
        request.addHeader("x-functions-key", terminalSecret)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    let refundTransactionResponse = try JSONDecoder().decode(RefundTransactionResponse.self, from: data)
                    
                    completion(true, refundTransactionResponse, nil)
                } catch let error {
                    completion(true, nil, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, nil, bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
    
    /// Allows POS integration developer delete a transaction that has not been redeemed by a user in Bucket's system.
    @objc public func deleteTransaction(
        customerCode: String,
        completion: @escaping (_ success: Bool, _ response: DeleteTransactionResponse?, _ error: Error?) -> Void
        ) {
        
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
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction").appendingPathComponent(customerCode)
        var request = URLRequest(url: url)
        request.setMethod(.delete)
        request.addHeader("retailerCode", retailerCode)
        request.addHeader("terminalCode", terminalCode)
        request.addHeader("country", country)
        request.addHeader("x-functions-key", terminalSecret)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    let deleteTransactionResponse = try JSONDecoder().decode(DeleteTransactionResponse.self, from: data)
                    
                    completion(true, deleteTransactionResponse, nil)
                } catch let error {
                    completion(true, nil, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, nil, bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
}

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
        
        if Terminal.requireEmployeeCode && createTransactionRequest.employeeCode.isNil {
            // Return and tell the developer that the employee code is required.
            completion(false, nil, BucketErrorResponse.invalidEmployeeCode)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction")
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, authenticationResult.error); return }
        
        request.setMethod(.post)

        if let employeeCode = createTransactionRequest.employeeCode { request.addHeader("employeeCode", employeeCode) }
        if createTransactionRequest.eventId != -1 { request.addHeader("eventId", String(createTransactionRequest.eventId)) }
        request.setBody(createTransactionRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {completion(false, nil, error); return }
            
            if response.isSuccess {
                let response = CreateTransactionResponse(json: data.asJSON)
                completion(true, response, nil)
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
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction").appendingPathComponent(customerCode)
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, authenticationResult.error); return }
        
        request.setMethod(.patch)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    let response = try JSONDecoder().decode(RefundTransactionResponse.self, from: data)
                    completion(true, response, nil)
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
        
        let url = Bucket.shared.environment.url.appendingPathComponent("transaction").appendingPathComponent(customerCode)
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, authenticationResult.error); return }
        
        request.setMethod(.delete)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    let response = try JSONDecoder().decode(DeleteTransactionResponse.self, from: data)
                    completion(true, response, nil)
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

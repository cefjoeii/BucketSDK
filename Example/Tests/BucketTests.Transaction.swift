//
//  BucketTests.Transaction.swift
//  BucketSDK_Tests
//
//  Created by Ceferino Jose II on 11/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

extension BucketTests {
    func testCreateSimpleTransaction() {
        let expectation = XCTestExpectation()
        
        let bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.55)
        let request = CreateTransactionRequest(amount: bucketAmount)
        
        Bucket.shared.createTransaction(request) { (success, response, error) in
            if success {
                XCTAssertNil(error)
                
                // Assert response attributes
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.customerCode)
                XCTAssertNotNil(response?.qrCode)
                XCTAssertNotEqual(response?.bucketTransactionId, -1)
                XCTAssertEqual(response?.amount, bucketAmount.roundingDecimalPlaces())
                XCTAssertNil(response?.locationId)
                XCTAssertNil(response?.clientTransactionId)
                
                self.customerCode = response?.customerCode ?? ""
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testCreateDetailedTransaction() {
        let expectation = XCTestExpectation()
        
        let bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 3.70)
        
        let request = CreateTransactionRequest(amount: bucketAmount)
        request.totalTransactionAmount = 6.30
        request.locationId = "locationId"
        request.clientTransactionId = "clientTransactionId"
        request.employeeCode = "1234"
        request.eventId = self.eventId
        
        Bucket.shared.createTransaction(request) { (success, response, error) in
            if success {
                XCTAssertNil(error)
                
                // Assert response attributes
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.customerCode)
                XCTAssertNotNil(response?.qrCode)
                XCTAssertNotEqual(response?.bucketTransactionId, -1)
                XCTAssertEqual(response?.amount, bucketAmount.roundingDecimalPlaces())
                XCTAssertEqual(response?.locationId, request.locationId)
                XCTAssertEqual(response?.clientTransactionId, request.clientTransactionId)
                
                self.customerCode = response?.customerCode ?? ""
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testRefundTransaction() {
        let expectation = XCTestExpectation()
        
        Bucket.shared.refundTransaction(customerCode: self.customerCode) { (success, response, error) in
            if success {
                XCTAssertNotNil(response)
                XCTAssertNil(error)
            } else {
                XCTAssertNil(response)
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testDeleteTransaction() {
        let expectation = XCTestExpectation()
        
        Bucket.shared.deleteTransaction(customerCode: self.customerCode) { (success, response, error) in
            if success {
                XCTAssertNotNil(response)
                XCTAssertNil(error)
            } else {
                XCTAssertNil(response)
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}

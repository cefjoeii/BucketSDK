//
//  SwiftTests.swift
//  BucketSDK_Tests
//
//  Created by Ryan Coyne on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

fileprivate extension Double {
    func roundingDecimalPlaces(to precision: Int = 2) -> Double? {
        return Double(String(format: "%.\(precision)f", self))
    }
}

class SwiftTests: XCTestCase {
    var customerCode = ""
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Bucket.shared.environment = .development
    }
    
    func testRegisterTerminal() {
        let expectation = XCTestExpectation()
        
        Credentials.retailerCode = "bckt-1"
        
        Bucket.shared.registerTerminal(country: "us") { (success, error) in
            if success {
                XCTAssertNil(error)
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetBillDenominations() {
        let expectation = XCTestExpectation()
        
        Bucket.shared.getBillDenominations { (success, error) in
            if success {
                XCTAssertNil(error)
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testBucketAmount() {
        // MARK: - Sane
        var bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.55)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.55)
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 12.34)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.34, "$0.34 should be bucketed for a $12.34 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.00)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.00, "$0.00 should be bucketed for a $1.00 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 5.00)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.00, "$0.00 should be bucketed for a $5.00 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.99)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.99, "$0.99 should be bucketed for a $0.99 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 9.99)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.99, "$0.99 should be bucketed for a $9.99 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.9)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.90, "$0.90 should be bucketed for a $0.9 change.")
        
        // MARK: - Dr. Strange
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.234)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.23, "$0.23 should be bucketed for a $1.234 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 2.345)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.35, "$0.35 should be bucketed for a $2.345 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 3.456)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.46, "$0.46 should be bucketed for a $3.456 change.")
        
        // MARK: - Murphy's Law
        // bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 9.999)
        // XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.00)
    }
    
    func testCreateSimpleTransaction() {
        let expectation = XCTestExpectation()
        
        let bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.55)
        let transactionRequest = TransactionRequest(amount: bucketAmount)
        
        Bucket.shared.createTransaction(transactionRequest) { (success, response, error) in
            if success {
                XCTAssertNil(error)
                
                // Assert response attributes
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
        
        let transactionRequest = TransactionRequest(amount: bucketAmount)
        transactionRequest.totalTransactionAmount = 6.30
        transactionRequest.locationId = "locationId"
        transactionRequest.clientTransactionId = "clientTransactionId"
        transactionRequest.employeeCode = "1234"
        transactionRequest.eventId = nil
        
        Bucket.shared.createTransaction(transactionRequest) { (success, response, error) in
            if success {
                XCTAssertNil(error)
                
                // Assert response attributes
                XCTAssertNotNil(response?.customerCode)
                XCTAssertNotNil(response?.qrCode)
                XCTAssertNotEqual(response?.bucketTransactionId, -1)
                XCTAssertEqual(response?.amount, bucketAmount.roundingDecimalPlaces())
                XCTAssertEqual(response?.locationId, transactionRequest.locationId)
                XCTAssertEqual(response?.clientTransactionId, transactionRequest.clientTransactionId)
                
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
        
        Bucket.shared.refundTransaction(customerCode: self.customerCode) { (success, error) in
            if success {
                XCTAssertNil(error)
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testDeleteTransaction() {
        let expectation = XCTestExpectation()
        
        Bucket.shared.deleteTransaction(customerCode: self.customerCode) { (success, error) in
            if success {
                XCTAssertNil(error)
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testInvalidGetReports() {
        var expectation = XCTestExpectation()
        var reportRequest = ReportRequest(day: "This is an invalid day date String.")
        Bucket.shared.getReports(reportRequest) { (success, response, error) in
            XCTAssertFalse(success)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.localizedDescription, "Please make sure that the date is valid.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        expectation = XCTestExpectation(description: "Fetch invalid reports.")
        reportRequest = ReportRequest(startString: "This is an invalid start date String.", endString: "This is an invalid end date String.")
        Bucket.shared.getReports(reportRequest) { (success, response, error) in
            XCTAssertFalse(success)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.localizedDescription, "Please make sure that the date is valid.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidGetReports() {
        var expectation = XCTestExpectation()
        
        var reportRequest = ReportRequest(startString: "2018-09-01 00:00:00+0800", endString: "2018-11-20 00:00:00+0800")
        
        Bucket.shared.getReports(reportRequest) { (success, response, error) in
            if (success) {
                XCTAssertNotNil(response)
                XCTAssertNil(error)
            } else {
                XCTAssertNil(response)
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
        expectation = XCTestExpectation()
        
        reportRequest = ReportRequest(startInt: 1535760000, endInt: 1542672000)
        
        Bucket.shared.getReports(reportRequest) { (success, response, error) in
            if (success) {
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

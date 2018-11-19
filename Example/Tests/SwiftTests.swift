//
//  SwiftTests.swift
//  BucketSDK_Tests
//
//  Created by Ryan Coyne on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

class SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Bucket.shared.environment = .development
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
            
        }
    }
    
    func testRegisterTerminal() {
        let expectation = XCTestExpectation(description: "Register the terminal.")
        
        Bucket.Credentials.retailerCode = "bckt-1"
        
        Bucket.shared.registerTerminal(countryCode: "us") { (success, error) in
            XCTAssertTrue(success, "The registerTerminal() function should work.")
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchBillDenominations() {
        let expectationForUSD = XCTestExpectation(description: "Fetch the USD denominations.")
        Bucket.shared.fetchBillDenominations { (success, error) in
            XCTAssertTrue(success, "USD denominations should be fetched.")
            XCTAssertNil(error)
            expectationForUSD.fulfill()
        }
        
        wait(for: [expectationForUSD], timeout: 3)
        
        let expectationForSGD = XCTestExpectation(description: "Fetch the SGD denominations.")
        Bucket.shared.fetchBillDenominations { (success, error) in
            XCTAssertTrue(success, "SGD denominations should be fetched.")
            XCTAssertNil(error)
            expectationForSGD.fulfill()
        }
        
        wait(for: [expectationForSGD], timeout: 3)
    }
    
    func testBucketAmount() {
        // MARK: - Normal
        var bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.55)
        XCTAssertEqual(bucketAmount, 0.55, "$0.55 should be bucketed for a $0.55 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 12.34)
        XCTAssertEqual(bucketAmount, 0.34, "$0.34 should be bucketed for a $12.34 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.00)
        XCTAssertEqual(bucketAmount, 0.00, "$0.00 should be bucketed for a $1.00 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 5.00)
        XCTAssertEqual(bucketAmount, 0.00, "$0.00 should be bucketed for a $5.00 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.99)
        XCTAssertEqual(bucketAmount, 0.99, "$0.99 should be bucketed for a $0.99 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 9.99)
        XCTAssertEqual(bucketAmount, 0.99, "$0.99 should be bucketed for a $9.99 change.")

        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.9)
        XCTAssertEqual(bucketAmount, 0.90, "$0.90 should be bucketed for a $0.9 change.")
        
        // MARK: - Dr. Strange
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.234)
        XCTAssertEqual(bucketAmount, 0.23, "$0.23 should be bucketed for a $1.234 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 2.345)
        XCTAssertEqual(bucketAmount, 0.35, "$0.35 should be bucketed for a $2.345 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 3.456)
        XCTAssertEqual(bucketAmount, 0.46, "$0.46 should be bucketed for a $3.456 change.")
        
        // MARK: - Murphy's Law
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 9.999)
        XCTAssertEqual(bucketAmount, 0.00)
    }
    
    func testCreateSimpleTransaction() {
        let expectation = XCTestExpectation(description: "Create a simple transaction.")
        
        let bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.55)
        
        let transaction = Transaction(amount: bucketAmount)
        transaction.create(transactionType: .regular) { (success, error) in
            if (success) {
                XCTAssertNil(error)
                
                // Assert response attributes
                XCTAssertNotNil(transaction.customerCode)
                XCTAssertNotNil(transaction.qrCode)
                XCTAssertNotEqual(transaction.bucketTransactionId, -1)
                XCTAssertEqual(transaction.amount, bucketAmount)
                XCTAssertNil(transaction.locationId)
                XCTAssertNil(transaction.clientTransactionId)
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 7)
    }
    
    func testCreateAlternativeTransaction() {
        let expectation = XCTestExpectation(description: "Create a transaction with alternative constructor.")
        
        let bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 5.32)
        
        let transaction = Transaction(
            amount: bucketAmount,
            totalTransactionAmount: 6,
            clientTransactionId: "clientTransactionId",
            employeeId: "employeeId"
        )
        
        transaction.create(transactionType: .regular) { (success, error) in
            if (success) {
                XCTAssertNil(error)
                
                // Assert response attributes
                XCTAssertNotNil(transaction.customerCode)
                XCTAssertNotNil(transaction.qrCode)
                XCTAssertNotEqual(transaction.bucketTransactionId, -1)
                XCTAssertEqual(transaction.amount, bucketAmount)
                XCTAssertEqual(transaction.clientTransactionId, "clientTransactionId")
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 7)
    }
    
    func testCreateDetailedRegularTransaction() {
        let expectation = XCTestExpectation(description: "Create a detailed regular transaction.")
        
        let bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 6.09)
        
        let transaction = Transaction(
            amount: bucketAmount,
            totalTransactionAmount: 6.50,
            clientTransactionId: "clientTransactionId",
            employeeId: "employeeId"
        )
        transaction.locationId = "locationId"
        transaction.sample = false
        
        transaction.create(transactionType: .regular) { (success, error) in
            if (success) {
                XCTAssertNil(error)
                
                // Assert response attributes
                XCTAssertNotNil(transaction.customerCode)
                XCTAssertNotNil(transaction.qrCode)
                XCTAssertNotEqual(transaction.bucketTransactionId, -1)
                XCTAssertEqual(transaction.amount, bucketAmount)
                XCTAssertEqual(transaction.clientTransactionId, "clientTransactionId")
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 7)
    }
    
    func testCreateADetailedEventTransaction() {
        let expectation = XCTestExpectation(description: "Create a detailed event transaction.")
        
        let bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 6.09)
        
        let transaction = Transaction(
            amount: bucketAmount,
            totalTransactionAmount: 6.50
        )
        transaction.eventId = 1
        transaction.eventName = "eventName"
        transaction.eventMessage = "eventMessage"
        
        transaction.create(transactionType: .event) { (success, error) in
            if (success) {
                XCTAssertNil(error)
                
                // Assert response attributes
                XCTAssertNotNil(transaction.customerCode)
                XCTAssertNotNil(transaction.qrCode)
                XCTAssertNotEqual(transaction.bucketTransactionId, -1)
                XCTAssertEqual(transaction.amount, bucketAmount)
                XCTAssertEqual(transaction.eventName, "eventName") 
                XCTAssertEqual(transaction.eventMessage, "eventMessage")
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 7)
    }
}

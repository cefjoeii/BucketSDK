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
        
        // MARK: - Strange
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.9)
        XCTAssertEqual(bucketAmount, 0.90, "$0.90 should be bucketed for a $0.90 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 9.999)
        XCTAssertEqual(bucketAmount, 0.00, "$0.00 should be bucketed for a $9.999 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.234)
        XCTAssertEqual(bucketAmount, 0.23, "$0.24 should be bucketed for a $1.234 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 2.345)
        XCTAssertEqual(bucketAmount, 0.35, "$0.35 should be bucketed for a $2.345 change.")
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 3.456)
        XCTAssertEqual(bucketAmount, 0.46, "$0.46 should be bucketed for a $3.456 change.")
    }
    
    func testCreateTransaction() {
        let expectation = XCTestExpectation(description: "Create a transaction.")
        
        // Make sure the retailer id, retailer secret, and terminal id are set.
        Bucket.Credentials.retailerCode = "6644211a-c02a-4413-b307-04a11b16e6a4"
        // Bucket.Credentials.terminalSecret = "9IlwMxfQLaOvC4R64GdX/xabpvAA4QBpqb1t8lJ7PTGeR4daLI/bxw=="
        // Bucket.Credentials.terminalId = "qwerty1234"
        
        let transaction = Bucket.Transaction(amount: 7843, clientTransactionId: "test")
        transaction.create { (response, success, error) in
            if (success) {
                XCTAssertNotNil(response)
                
                if let response = response {
                    XCTAssertEqual(response.amount, 7843)
                    XCTAssertEqual(response.clientTransactionId, "test")
                    XCTAssertNotEqual(response.customerCode, "")
                    XCTAssertNotNil(response.qrCodeContent)
                }
                
                XCTAssertTrue(success)
                XCTAssertNil(error)
            } else {
                XCTAssertNil(response)
                XCTAssertFalse(success)
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}

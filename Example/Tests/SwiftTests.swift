//
//  SwiftTests.swift
//  BucketSDK_Tests
//
//  Created by Ryan Coyne on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

extension Double {
    func roundingDecimalPlaces(to precision: Int = 2) -> Double? {
        return Double(String(format: "%.\(precision)f", self))
    }
}

class SwiftTests: XCTestCase {
    var customerCode = ""
    var eventId = -1
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Bucket.shared.environment = .development
    }
    
    func testRegisterTerminal() {
        let expectation = XCTestExpectation()
        
        Bucket.shared.registerTerminal(retailerCode: "bckt-1", country: "us") { (success, error) in
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
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.34)
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.00)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.00)
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 5.00)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.00)
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.99)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.99)
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 9.99)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.99)
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 0.9)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.90)
        
        // MARK: - Dr. Strange
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 1.234)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.23)
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 2.345)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.35)
        
        bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 3.456)
        XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.46)
        
        // MARK: - Murphy's Law
        // bucketAmount = Bucket.shared.bucketAmount(changeDueBack: 9.999)
        // XCTAssertEqual(bucketAmount.roundingDecimalPlaces(), 0.00)
    }
    
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
        request.eventId = nil
        
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
    
    func testInvalidGetReports() {
        var expectation = XCTestExpectation()
        var request = GetReportRequest(day: "This is an invalid day date String.")
        Bucket.shared.getReports(request) { (success, response, error) in
            XCTAssertFalse(success)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.localizedDescription, "Please make sure that the date is valid.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        expectation = XCTestExpectation(description: "Fetch invalid reports.")
        request = GetReportRequest(startString: "This is an invalid start date String.", endString: "This is an invalid end date String.")
        Bucket.shared.getReports(request) { (success, response, error) in
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
        var request = GetReportRequest(startString: "2018-09-01 00:00:00+0800", endString: "2018-11-20 00:00:00+0800")
        Bucket.shared.getReports(request) { (success, response, error) in
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
        request = GetReportRequest(startInt: 1535760000, endInt: 1542672000)
        Bucket.shared.getReports(request) { (success, response, error) in
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
    
    func testInvalidGetEvents() {
        let expectation = XCTestExpectation()
        let request = GetEventsRequest(startString: "This is an invalid start date String.", endString: "This is an invalid end date String.")
        Bucket.shared.getEvents(request) { (success, response, error) in
            XCTAssertFalse(success)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.localizedDescription, "Please make sure that the date is valid.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidGetEvents() {
        var expectation = XCTestExpectation()
        var request = GetEventsRequest(startString: "2018-11-27 00:00:00+0800", endString: "2018-11-27 23:59:59+0800")
        Bucket.shared.getEvents(request) { (success, response, error) in
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
        
        expectation = XCTestExpectation()
        request = GetEventsRequest(startInt: 1543276800, endInt: 1543363199)
        Bucket.shared.getEvents(request) { (success, response, error) in
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
        
        expectation = XCTestExpectation()
        request = GetEventsRequest(id: 7)
        Bucket.shared.getEvents(request) { (success, response, error) in
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
    
    func testInvalidCreateEvent() {
        let expectation = XCTestExpectation()
        let request = CreateEventRequest(
            eventName: "iOS SDK Unit Test Event Name",
            eventMessage: "iOS SDK Unit Test Event Message",
            startString: "This is an invalid start date String.",
            endString: "This is an invalid end date String."
        )
        
        Bucket.shared.createEvent(request) { (success, response, error) in
            XCTAssertFalse(success)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.localizedDescription, "Please make sure that the date is valid.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidCreateEvent() {
        let expectation = XCTestExpectation()
        let request = CreateEventRequest(
            eventName: "iOS SDK Unit Test Event Name",
            eventMessage: "iOS SDK Unit Test Event Message",
            startString: "2018-11-25 00:00:00+0800",
            endString: "2018-11-25 23:59:59+0800"
        )
        
        Bucket.shared.createEvent(request) { (success, response, error) in
            if success {
                XCTAssertNotNil(response)
                XCTAssertNil(error)
                
                self.eventId = response?.id ?? -1
            } else {
                XCTAssertNil(response)
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testInvalidUpdateEvent() {
        let expectation = XCTestExpectation()
        let request = UpdateEventRequest(
            id: 15,
            eventName: "iOS SDK Unit Test Event Namee (Update Event)",
            eventMessage: "iOS SDK Unit Test Event Message (Update Event)",
            startString: "This is an invalid start date String.",
            endString: "This is an invalid end date String."
        )
        
        Bucket.shared.updateEvent(request) { (success, response, error) in
            XCTAssertFalse(success)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.localizedDescription, "Please make sure that the date is valid.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidUpdateEvent() {
        let expectation = XCTestExpectation()
        let request = UpdateEventRequest(
            id: self.eventId,
            eventName: "iOS SDK Unit Test Event Name (Update Event)",
            eventMessage: "iOS SDK Unit Test Event Message (Update Event)",
            startString: "2018-11-25 00:00:00+0800",
            endString: "2018-11-25 23:59:59+0800"
        )
        
        Bucket.shared.updateEvent(request) { (success, response, error) in
            if success {
                XCTAssertNotNil(response)
                XCTAssertNil(error)
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testDeleteEvent() {
        let expectation = XCTestExpectation()

        Bucket.shared.deleteEvent(id: self.eventId) { (success, response, error) in
            if success {
                XCTAssertNotNil(response)
                XCTAssertNil(error)
            } else {
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}

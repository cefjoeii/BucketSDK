//
//  BucketTests.Reporting.swift
//  BucketSDK_Tests
//
//  Created by Ceferino Jose II on 11/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

extension BucketTests {
    func testInvalidGetReports() {
        var expectation = XCTestExpectation()
        var request = GetReportRequest(day: "This is an invalid day date String.")
        Bucket.shared.getReport(request) { (success, response, canPage, error) in
            XCTAssertFalse(success)
            XCTAssertNil(response)
            XCTAssertTrue(canPage)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.localizedDescription, "Please make sure that the date is valid.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        expectation = XCTestExpectation(description: "Fetch invalid reports.")
        request = GetReportRequest(startString: "This is an invalid start date String.", endString: "This is an invalid end date String.")
        Bucket.shared.getReport(request) { (success, response, canPage, error) in
            XCTAssertFalse(success)
            XCTAssertNil(response)
            XCTAssertTrue(canPage)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.localizedDescription, "Please make sure that the date is valid.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidGetReports() {
        var expectation = XCTestExpectation()
        var request = GetReportRequest(startString: self.dateNowStartEndString.start, endString: self.dateNowStartEndString.end)
        Bucket.shared.getReport(request) { (success, response, canPage, error) in
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
        request = GetReportRequest(startInt: self.dateNowStartEndInt.start, endInt: self.dateNowStartEndInt.end)
        Bucket.shared.getReport(request) { (success, response, canPage, error) in
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

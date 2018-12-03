//
//  BucketTests.Events.swift
//  BucketSDK_Tests
//
//  Created by Ceferino Jose II on 11/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

extension BucketTests {
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
        var request = GetEventsRequest(startString: self.dateNowStartEndString.start, endString: self.dateNowStartEndString.end)
        
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
        request = GetEventsRequest(startInt: self.dateNowStartEndInt.start, endInt: self.dateNowStartEndInt.end)
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
    
    func testValidGetEventsReport() {
        var expectation = XCTestExpectation()
        var request = GetEventsReportRequest(startString: self.dateNowStartEndString.start, endString: self.dateNowStartEndString.end)
        
        Bucket.shared.getEventsReport(request) { (success, response, error) in
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
        request = GetEventsReportRequest(startInt: self.dateNowStartEndInt.start, endInt: self.dateNowStartEndInt.end)
        Bucket.shared.getEventsReport(request) { (success, response, error) in
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
        request = GetEventsReportRequest(id: 58)
        Bucket.shared.getEventsReport(request) { (success, response, error) in
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
            eventName: "(Create) iOS SDK Unit Test Event Name",
            eventMessage: "(Create) iOS SDK Unit Test Event Message",
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
        var expectation = XCTestExpectation()
        var request = CreateEventRequest(
            eventName: "(Create) iOS SDK Unit Test Event Name",
            eventMessage: "(Create) iOS SDK Unit Test Event Message",
            startString: self.dateNowStartEndString.start,
            endString: self.dateNowStartEndString.end
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
        
        expectation = XCTestExpectation()
        request = CreateEventRequest(
            eventName: "(Create) iOS SDK Unit Test Event Name",
            eventMessage: "(Create) iOS SDK Unit Test Event Message",
            startInt: self.dateNowStartEndInt.start,
            endInt: self.dateNowStartEndInt.end
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
            id: self.eventId,
            eventName: "(Update) iOS SDK Unit Test Event Name",
            eventMessage: "(Update) iOS SDK Unit Test Event Message",
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
        var expectation = XCTestExpectation()
        var request = UpdateEventRequest(
            id: self.eventId,
            eventName: "(Update) iOS SDK Unit Test Event Name",
            eventMessage: "(Update) iOS SDK Unit Test Event Message",
            startString: self.dateNowStartEndString.start,
            endString: self.dateNowStartEndString.end
        )
        Bucket.shared.updateEvent(request) { (success, response, error) in
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
        request = UpdateEventRequest(
            id: self.eventId,
            eventName: "(Update) iOS SDK Unit Test Event Name",
            eventMessage: "(Update) iOS SDK Unit Test Event Message",
            startInt: self.dateNowStartEndInt.start,
            endInt: self.dateNowStartEndInt.end
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

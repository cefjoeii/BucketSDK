//
//  BucketTests.Export.swift
//  BucketSDK_Example
//
//  Created by Ceferino Jose II on 12/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

extension BucketTests {
    func testExportEvents() {
        let expectation = XCTestExpectation()
        
        let request = ExportEventsRequest(email: "ceferinojo@cloudstaff.com")
        request.limit = 10
        
        Bucket.shared.exportEvents(request) { (success, response, error) in
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

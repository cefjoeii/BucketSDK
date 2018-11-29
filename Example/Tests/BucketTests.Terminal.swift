//
//  BucketTests.Terminal.swift
//  BucketSDK_Tests
//
//  Created by Ceferino Jose II on 11/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

extension BucketTests {
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
}

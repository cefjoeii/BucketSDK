//
//  BucketTests.BillDenominations.swift
//  BucketSDK_Tests
//
//  Created by Ceferino Jose II on 11/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

extension BucketTests {
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
}

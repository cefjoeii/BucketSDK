//
//  BucketTests.swift
//  BucketSDK_Tests
//
//  Created by Ryan Coyne on 5/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BucketSDK

class BucketTests: XCTestCase {
    var customerCode = ""
    var eventId = -1
    
    lazy var dateNowStartEndString = self.getDateNowStartEndString(timeZone: TimeZone.init(abbreviation: "UTC"))
    lazy var dateNowStartEndInt = self.getDateNowStartEndInt(timeZone: TimeZone.init(abbreviation: "UTC"))

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Bucket.shared.environment = .development
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
}

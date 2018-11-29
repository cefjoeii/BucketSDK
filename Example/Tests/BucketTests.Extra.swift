//
//  BucketTests.Extra.swift
//  BucketSDK_Tests
//
//  Created by Ceferino Jose II on 11/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

extension Double {
    func roundingDecimalPlaces(to precision: Int = 2) -> Double? {
        return Double(String(format: "%.\(precision)f", self))
    }
}

extension BucketTests {
    func getDateNowString(format: String? = "yyyy-MM-dd HH:mm:ssZZZ", timeZone: TimeZone? = TimeZone.current) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        
        return formatter.string(from: date)
    }
    
    func getDateNowStartEndString(timeZone tz: TimeZone? = TimeZone.current) -> (start: String, end: String) {
        let start = "\(getDateNowString(format: "yyyy-MM-dd", timeZone: tz)) 00:00:00\(getDateNowString(format: "ZZZ", timeZone: tz))"
        let end = "\(getDateNowString(format: "yyyy-MM-dd", timeZone: tz)) 23:59:59\(getDateNowString(format: "ZZZ", timeZone: tz))"
        return (start, end)
    }
    
    func getDateNowStartEndInt(timeZone tz: TimeZone? = TimeZone.current) -> (start: Int, end: Int) {
        let startEndString = getDateNowStartEndString(timeZone: tz)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        formatter.timeZone = tz
        
        let start = Int(formatter.date(from: startEndString.start)!.timeIntervalSince1970)
        let end = Int(formatter.date(from: startEndString.end)!.timeIntervalSince1970)
        
        return (start, end)
    }
}

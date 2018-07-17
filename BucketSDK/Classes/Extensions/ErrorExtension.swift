//
//  ErrorExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

public extension Error {
    
    static var invalidCredentials : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Please check Retailer Id and Secret Code."]) }
    static var verificationError : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Account requires verification or verification has lapsed. Please contact Bucket support."]) }
    static var zeroTransaction : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Non-zero amount required."]) }
    static var noIntervalId : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "This interval id has been previously closed."]) }
    static var unknown : Error { return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unknown issue.  Please try again later."]) }
}

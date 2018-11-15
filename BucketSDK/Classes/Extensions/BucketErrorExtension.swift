//
//  BucketErrorExtension.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/17/18.
//

import Foundation

extension BucketError: Error {
    static var unknown: Error {
        return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unknown issue.  Please try again later."])
    }
    
    static var invalidCountryCode: Error {
        return NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "No such country code found"])
    }
    
    // MARK: - Old
    static var invalidRetailer: Error {
        return NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Please check your retailer code."])
    }
    
    static var noIntervalId: Error {
        return NSError(domain: "", code: 405, userInfo: [NSLocalizedDescriptionKey: "An interval id is required."])
    }
    
    static var closedIntervalId: Error {
        return NSError(domain: "", code: 406, userInfo: [NSLocalizedDescriptionKey: "This interval id has been previously closed."])
    }
    
    static var zeroTransaction: Error {
        return NSError(domain: "", code: 407, userInfo: [NSLocalizedDescriptionKey: "Non-zero amount required."])
    }
    
    static var verificationError: Error {
        return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Account requires verification or verification has lapsed.  Please contact Bucket support."])
    }

    static var noCurrencyFound: Error {
        return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No currency found."])
    }
}

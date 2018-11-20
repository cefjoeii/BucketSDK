//
//  BucketErrorResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/21/18.
//

import Foundation

struct BucketErrorResponse: Decodable {
    let errorCode: String?
    let message: String?
    
    init(json: [String: Any]) {
        errorCode = json["errorCode"] as? String
        message = json["message"] as? String
    }

    func asError(_ code: Int?) -> Error {
        return NSError(domain: "", code: code ?? 400, userInfo: [NSLocalizedDescriptionKey: message ?? "Unknown issue. Please try again later."])
    }
    
    // MARK: - Offline
    static var unknown: Error {
        return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unknown issue.  Please try again later."])
    }
    
    static var invalidCountryCode: Error {
        return NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "No such country code found."])
    }
    
    static var invalidRetailer: Error {
        return NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Please Check Retailer Id and Secret Code."])
    }
    
    static var invalidRange: Error {
        return NSError(domain: "", code: 402, userInfo: [NSLocalizedDescriptionKey: "Please make sure that the range is valid."])
    }
    
    static var noTerminalId: Error {
        return NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "You must send in a 'terminalId' key with the serial number of the device as the value."])
    }
    
    static var invalidCode: Error {
        return NSError(domain: "", code: 450, userInfo: [NSLocalizedDescriptionKey: "Please check your customer code."])
    }
}

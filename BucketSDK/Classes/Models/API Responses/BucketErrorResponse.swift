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
        return NSError(domain: "", code: code ?? 520, userInfo: [NSLocalizedDescriptionKey: message ?? BucketErrorResponse.unknown.localizedDescription])
    }
    
    // MARK: - Offline
    static var eventIdDNE: Error {
         return NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "The event ID does not exist."])
    }
    
    static var invalidRetailer: Error {
        return NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Please check retailer id and secret code."])
    }
    
    static var noTerminalId: Error {
        return NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "You must send in a 'terminalCode' key with the serial number of the device as the value."])
    }
    
    static var invalidCountryCode: Error {
        return NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "No such country code found."])
    }
    
    static var invalidEmployeeCode: Error {
        return NSError(domain: "", code: 412, userInfo: [NSLocalizedDescriptionKey: "Please check your employee code."])
    }
    
    static var invalidDateRange: Error {
        return NSError(domain: "", code: 419, userInfo: [NSLocalizedDescriptionKey: "Please make sure that the date is valid."])
    }
    
    static var invalidCode: Error {
        return NSError(domain: "", code: 450, userInfo: [NSLocalizedDescriptionKey: "Please check your customer code."])
    }
    
    static var unknown: Error {
        return NSError(domain: "", code: 520, userInfo: [NSLocalizedDescriptionKey: "Unknown issue.  Please try again later."])
    }
}

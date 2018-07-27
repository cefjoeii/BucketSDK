//
//  BucketError.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/21/18.
//

import Foundation

struct BucketError: Decodable {
    
    let errorCode: String?
    let message: String?
    
    init(json: [String: Any]) {
        errorCode = json["errorCode"] as? String
        message = json["message"] as? String
    }

    func asError(_ code: Int?) -> Error {
        return NSError(domain: "", code: code ?? 400, userInfo: [NSLocalizedDescriptionKey: message ?? "Unknown issue. Please try again later."])
    }
}

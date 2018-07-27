//
//  RegisterDevice.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 7/20/18.
//

import Foundation

struct RegisterTerminalResponse: Decodable {
    
    let isApproved: Bool?
    let apiKey: String?
    
    init(json: [String: Any]) {
        isApproved = json["isApproved"] as? Bool
        apiKey = json["apiKey"] as? String
    }
}

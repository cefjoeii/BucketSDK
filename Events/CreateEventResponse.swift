//
//  CreateEventResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/27/18.
//

import Foundation

@objc public class CreateEventResponse: NSObject, Decodable {
    @objc public let id: Int
    @objc public let result: String?
    
    init(json: [String: Any]) {
        self.id = json["id"] as? Int ?? -1
        self.result = json["result"] as? String
    }
}

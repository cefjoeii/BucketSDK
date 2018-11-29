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
    
    private enum CodingKeys: String, CodingKey {
        case id, result
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.result = try container.decodeIfPresent(String.self, forKey: .result)
    }
}

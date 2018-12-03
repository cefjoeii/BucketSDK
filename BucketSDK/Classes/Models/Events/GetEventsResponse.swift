//
//  GetEventsResponse.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/21/18.
//

import Foundation

@objc public class GetEventsResponse: NSObject, Decodable {
    @objc public let events: [Event]?
}

@objc public class Event: NSObject, Decodable {
    @objc public let id: Int
    @objc public let eventName: String?
    @objc public let eventMessage: String?
    @objc public let startDate: String?
    @objc public let endDate: String?
    @objc public let created: String?
    @objc public let modified: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, eventName, eventMessage, startDate, endDate, created, modified
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.eventName = try container.decodeIfPresent(String.self, forKey: .eventName)
        self.eventMessage = try container.decodeIfPresent(String.self, forKey: .eventMessage)
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.created = try container.decodeIfPresent(String.self, forKey: .created)
        self.modified = try container.decodeIfPresent(String.self, forKey: .modified)
    }
}

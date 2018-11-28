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
    
    init(json: [String: Any]) {
        self.id = json["id"] as? Int ?? -1
        self.eventName = json["eventName"] as? String
        self.eventMessage = json["eventMessage"] as? String
        self.startDate = json["startDate"] as? String
        self.endDate = json["endDate"] as? String
        self.created = json["created"] as? String
        self.modified = json["modified"] as? String
    }
}

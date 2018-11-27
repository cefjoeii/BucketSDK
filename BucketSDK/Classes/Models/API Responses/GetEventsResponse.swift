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
    @objc public let id: Int = -1
    @objc public let eventName: String?
    @objc public let eventMessage: String?
    @objc public let startDate: String?
    @objc public let endDate: String?
    @objc public let created: String?
    @objc public let modified: String?
}

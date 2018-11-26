//
//  CreateEventRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/26/18.
//

import Foundation

@objc public class CreateEventRequest: NSObject {
    // MARK: - Body
    @objc public let eventName: String
    @objc public let eventMessage: String
    @objc public let start: String
    @objc public let end: String
    
    @objc public init(eventName: String, eventMessage: String, start: String, end: String) {
        self.eventName = eventName
        self.eventMessage = eventMessage
        self.start = start
        self.end = end
    }
    
    var body: [String: Any] {
        var json = [String: Any]()
        json["eventName"] = self.eventName
        json["eventMessage"] = self.eventMessage
        json["start"] = self.start
        json["end"] = self.end
        
        return json
    }
}

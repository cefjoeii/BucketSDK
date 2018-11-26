//
//  CreateEventRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/26/18.
//

import Foundation

@objc public class CreateEventRequest: NSObject {
    // MARK: - Body
    /// The name of the event.
    @objc public let eventName: String
    
    /// The message of the event.
    @objc public let eventMessage: String
    
    /// The date format is yyyy-MM-dd HH:mm:ssZZZ
    @objc public let start: String
    
    /// The date format is yyyy-MM-dd HH:mm:ssZZZ
    @objc public let end: String
    
    /// - Parameter eventName: The name of the event.
    /// - Parameter eventMessage: The message of the event.
    /// - Parameter start: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    /// - Parameter end: The date format is yyyy-MM-dd HH:mm:ssZZZ.
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

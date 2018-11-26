//
//  UpdateEventRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/26/18.
//

import Foundation

@objc public class UpdateEventRequest: NSObject, CommonEventRequestDelegate {
    // MARK: - Body
    var range: [String: Any]
    
    /// The id of the event.
    /// This is to modify the message or the name.
    @objc public let id: Int
    
    /// The name of the event.
    @objc public let eventName: String
    
    /// The message of the event.
    @objc public let eventMessage: String
    
    /// - Parameter eventName: The name of the event.
    /// - Parameter eventMessage: The message of the event.
    /// - Parameter start: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    /// - Parameter end: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    @objc public init(id: Int, eventName: String, eventMessage: String, startString start: String, endString end: String) {
        self.id = id
        self.eventName = eventName
        self.eventMessage = eventMessage
        self.range = ["start": start, "end": end]
    }
    
    /// - Parameter eventName: The name of the event.
    /// - Parameter eventMessage: The message of the event.
    /// - Parameter start: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    /// - Parameter end: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    @objc public init(id: Int, eventName: String, eventMessage: String, start: String, end: String) {
        self.id = id
        self.eventName = eventName
        self.eventMessage = eventMessage
        self.range = ["start": start, "end": end]
    }
    
    var body: [String: Any] {
        var json = self.range
        json["id"] = self.id
        json["eventName"] = self.eventName
        json["eventMessage"] = self.eventMessage
        
        return json
    }
}

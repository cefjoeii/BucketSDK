//
//  UpdateEventRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/26/18.
//

import Foundation

@objc public class UpdateEventRequest: NSObject {
    // MARK: - Body
    var range = [String: Any]()
    
    /// The id of the event.
    /// This is to modify the message or the name.
    @objc public dynamic var id: Int
    
    /// The name of the event.
    @objc public dynamic var eventName: String?
    
    /// The message of the event.
    @objc public dynamic var eventMessage: String?
    
    /// - Parameter id: The id of the event.
    /// - Parameter eventName: The name of the event.
    /// - Parameter eventMessage: The message of the event.
    /// - Parameter start: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    /// - Parameter end: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    @objc public init(id: Int, eventName: String? = nil, eventMessage: String? = nil, startString start: String? = nil, endString end: String? = nil) {
        self.id = id
        self.eventName = eventName
        self.eventMessage = eventMessage
        if let start = start { self.range["start"] = start }
        if let end = end { self.range["end"] = end }
    }
    
    /// - Parameter id: The id of the event.
    /// - Parameter eventName: The name of the event.
    /// - Parameter eventMessage: The message of the event.
    /// - Parameter startInt: The starting epoch integer in SECONDS that is UTC based.
    /// - Parameter endInt: The ending epoch integer in SECONDS that is UTC based.
    @objc public init(id: Int, eventName: String? = nil, eventMessage: String? = nil, startInt start: Int = -1, endInt end: Int = -1) {
        self.id = id
        self.eventName = eventName
        self.eventMessage = eventMessage
        if start != -1 { self.range["start"] = start }
        if end != -1 { self.range["end"] = end }
    }
    
    var body: [String: Any] {
        var json = self.range
        json["id"] = self.id
        if let eventName = self.eventName { json["eventName"] = eventName }
        if let eventMessage = self.eventMessage { json["eventMessage"] = eventMessage }
        
        return json
    }
}

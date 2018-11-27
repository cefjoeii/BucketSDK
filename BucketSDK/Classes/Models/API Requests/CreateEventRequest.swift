//
//  CreateEventRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/26/18.
//

import Foundation

@objc public class CreateEventRequest: NSObject {
    // MARK: - Body
    var range: [String: Any]
    
    /// The name of the event.
    @objc public dynamic var eventName: String
    
    /// The message of the event.
    @objc public dynamic var eventMessage: String
    
    /// - Parameter eventName: The name of the event.
    /// - Parameter eventMessage: The message of the event.
    /// - Parameter startString: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    /// - Parameter endString: The date format is yyyy-MM-dd HH:mm:ssZZZ.
    @objc public init(eventName: String, eventMessage: String, startString start: String, endString end: String) {
        self.eventName = eventName
        self.eventMessage = eventMessage
        self.range = ["start": start, "end": end]
    }
    
    /// - Parameter eventName: The name of the event.
    /// - Parameter eventMessage: The message of the event.
    /// - Parameter startInt: The starting epoch integer in SECONDS that is UTC based.
    /// - Parameter endInt: The ending epoch integer in SECONDS that is UTC based.
    @objc public init(eventName: String, eventMessage: String, startInt start: Int, endInt end: Int) {
        self.eventName = eventName
        self.eventMessage = eventMessage
        self.range = ["start": start, "end": end]
    }
    
    var body: [String: Any] {
        var json = self.range
        json["eventName"] = self.eventName
        json["eventMessage"] = self.eventMessage
        
        return json
    }
}

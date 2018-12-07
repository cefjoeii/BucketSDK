//
//  ExportEventsRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 12/6/18.
//

import Foundation

@objc public class ExportEventsRequest: NSObject {
    /// MARK: - Queries
    /// The file type of the exported data.
    @objc public dynamic var exportType: String? = "csv"
    
    /// The offset of the request. This will **position** the array of transactions for the request.
    /// This will affect the events if you do not send in the eventId,
    /// or it will affect the transactions if you do send in the eventId.
    @objc public dynamic var offset: Int = 0
    
    /// The limit of the request. This limits the number of transactions
    /// that are returned in the transactions if you sent in an eventId.
    /// This limits the events if you do not send in an eventId.
    @objc public dynamic var limit: Int = -1
    
    /// MARK: - Body
    @objc public dynamic var email: String
    
    @objc public dynamic var eventId: Int = -1
    
    @objc public init(email: String) {
        self.email = email
    }
    
    var queries: [String: Any] {
        var json = [String: Any]()
        json["exportType"] = self.exportType
        json["offset"] = self.offset
        if self.limit != -1 { json["limit"] = self.limit }
        
        return json
    }
    
    var body: [String: Any] {
        var json = [String: Any]()
        json["email"] = self.email
        if self.eventId != -1 { json["eventId"] = self.eventId }
        
        return json
    }
}

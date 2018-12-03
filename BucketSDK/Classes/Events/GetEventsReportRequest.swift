//
//  GetEventsReportRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/29/18.
//

import Foundation

@objc public class GetEventsReportRequest: NSObject {
    // MARK: - Headers
    /// This will **position** the array of transactions for the request.
    @objc public dynamic var offset: Int = 0
    
    /// This limits the **number** of transactions that are returned in the transactions array.
    /// The **maximum limit** for this endpoint is **500**.
    @objc public dynamic var limit: Int = 200
    
    // MARK: - Body
    var range: [String: Any]
    
    /// - Parameter startString: This date is formatted as 'yyyy-MM-dd HH:m:ssZZZ'
    /// - Parameter endString: This date is formatted as 'yyyy-MM-dd HH:m:ssZZZ'
    @objc public init(startString start: String, endString end: String) {
        self.range = ["start": start, "end": end]
    }
    
    /// - Parameter startInt: This is the starting epoch integer in SECONDS that is UTC based.
    /// - Parameter endInt: This is the ending epoch integer in SECONDS that is UTC based.
    @objc public init(startInt start: Int, endInt end: Int) {
        self.range = ["start": start, "end": end]
    }
    
    /// - Parameter id: The specific id of the event.
    @objc public init(id: Int) {
        self.range = ["id": id]
    }
    
    var body: [String: Any] {
        return self.range
    }
}

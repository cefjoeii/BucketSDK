//
//  ReportRequest.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/23/18.
//

import Foundation

@objc public class ReportRequest: NSObject {
    // MARK: - Headers
    /// This is **only required if** the retailer is **set to require employeeCodes**.
    /// If you want to change the report to show only the transactions and total for a specific employee,
    /// send the employeeCode in JSON.
    @objc public dynamic var employeeCode: String?
    
    /// If this is included in the report, it will include only the transactions
    /// that have been created under this event.
    @objc public dynamic var eventId: String?
    
    /// This will **position** the array of transactions for the request.
    @objc public dynamic var offset: Int = 0
    
    /// This limits the **number** of transactions that are returned in the transactions array.
    /// The **maximum limit** for this endpoint is **500**.
    @objc public dynamic var limit: Int = 200
    
    // MARK: - Body
    var range: [String: Any]
    
    /// This is the serial number of the terminal for the report.
    /// **This could be different than the header value,
    /// as the header value is always the terminal for the request.**
    @objc public dynamic var reportTerminalCode: String?
    
    /// This is the employeeCode to change the report results.
    @objc public dynamic var reportEmployeeCode: String?
    
    /// This would be to filter the results based on a report that is given for all employees.
    /// Since you wouldn't know their employeeCode, you can filter the report by their id.
    @objc public dynamic var reportEmployeeId: Int = -1
    
    @objc public init(startString start: String, endString end: String) {
        self.range = ["start": start, "end": end]
    }
    
    @objc public init(startInt start: Int, endInt end: Int) {
        self.range = ["start": start, "end": end]
    }
    
    @objc public init(day: String) {
        self.range = ["day": day]
    }
    
    var body: [String: Any] {
        var json = self.range
        if let reportTerminalCode = self.reportTerminalCode { json["reportTerminalCode"] = reportTerminalCode }
        if let reportEmployeeCode = self.reportEmployeeCode { json["employeeCode"] = reportEmployeeCode }
        if self.reportEmployeeId != -1 { json["employeeId"] = self.reportEmployeeId }
        
        return json
    }
}

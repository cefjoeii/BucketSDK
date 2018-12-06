//
//  Bucket.Reporting.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/23/18.
//

import Foundation

extension Bucket {
    /// Allows a POS integration developer to give a summed history of the transactions.
    @objc public func getReport(
        _ getReportRequest: GetReportRequest,
        completion: @escaping ((_ success: Bool, _ response: GetReportsResponse?, _ canPage: Bool, _ error: Error?) -> Void)
        ) {
        
        // Some of these pitfalls should never occur unless the SDK is manually modified.
        switch getReportRequest.range.count {
        case 1:
            if !(getReportRequest.range["day"] is String && (getReportRequest.range["day"] as! String).isValidDayDate) {
                // Return if the day is not a String and its format is invalid.
                completion(false, nil, true, BucketErrorResponse.invalidDateRange)
                return
            }
        case 2:
            if getReportRequest.range["start"] is String && getReportRequest.range["end"] is String {
                if (getReportRequest.range["start"] as! String).isNotValidStartEndDate || (getReportRequest.range["end"] as! String).isNotValidStartEndDate {
                    // Return if neither start nor end is a valid date.
                    completion(false, nil, true, BucketErrorResponse.invalidDateRange)
                    return
                }
            } else if !(getReportRequest.range["start"] is Int && getReportRequest.range["end"] is Int) {
                // Return if the start and end is neither a pair of Ints nor a pair of Strings above.
                completion(false, nil, true, BucketErrorResponse.invalidDateRange)
                return
            }
        default:
            // Return if the range dictionary count is invalid.
            completion(false, nil, true, BucketErrorResponse.invalidDateRange)
            return
        }
        
        // Return and tell the developer that the employee code is required.
        if Terminal.requireEmployeeCode && getReportRequest.employeeCode.isNil {
            completion(false, nil, true, BucketErrorResponse.invalidEmployeeCode)
            return
        }
        
        var url = Bucket.shared.environment.url
        url.appendPathComponent("report")
        url.appendQueriesComponent(["offset": getReportRequest.offset, "limit": getReportRequest.limit])
        
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else {
            completion(false, nil, true, authenticationResult.error)
            return
        }
        
        request.setMethod(.post)
        if let employeeCode = getReportRequest.employeeCode { request.addHeader("employeeCode", employeeCode) }
        if let eventId = getReportRequest.eventId { request.addHeader("eventId", eventId) }
        
        request.setBody(getReportRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, true, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(GetReportsResponse.self, from: data)
                    
                    var canPage = true
                    
                    if let count = response.transactions?.count {
                        canPage = (count >= getReportRequest.limit)
                    }
                    
                    completion(true, response, canPage, nil)
                } catch let error {
                    completion(false, nil, true, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, nil, bucketErrorResponse?.errorCode != "EmptyReport", bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
}

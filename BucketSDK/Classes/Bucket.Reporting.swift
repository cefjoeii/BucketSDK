//
//  Bucket.Reporting.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/23/18.
//

import Foundation

extension Bucket {
    /// Allows a POS integration developer to give a summed history of the transactions.
    @objc public func getReports(
        _ reportRequest: ReportRequest,
        completion: @escaping ((_ success: Bool, _ response: GetReportsResponse?, _ error: Error?) -> Void)
        ) {
        
        // Some of these pitfalls should never occur unless the SDK is manually modified.
        switch reportRequest.range.count {
        case 1:
            if !(reportRequest.range["day"] is String && (reportRequest.range["day"] as! String).isValidDayDate) {
                // Return if the day is not a String and its format is invalid.
                completion(false, nil, BucketErrorResponse.invalidDateRange)
                return
            }
        case 2:
            if reportRequest.range["start"] is String && reportRequest.range["end"] is String {
                if (reportRequest.range["start"] as! String).isNotValidStartEndDate || (reportRequest.range["end"] as! String).isNotValidStartEndDate {
                    // Return if neither start nor end is a valid date.
                    completion(false, nil, BucketErrorResponse.invalidDateRange)
                    return
                }
            } else if !(reportRequest.range["start"] is Int && reportRequest.range["end"] is Int) {
                // Return if the start and end is neither a pair of Ints nor a pair of Strings above.
                completion(false, nil, BucketErrorResponse.invalidDateRange)
                return
            }
        default:
            // Return if the range dictionary count is invalid.
            completion(false, nil, BucketErrorResponse.invalidDateRange)
            return
        }
        
        // Return and tell the developer that the employee code is required.
        if Credentials.requireEmployeeCode && reportRequest.employeeCode.isNil {
            completion(false, nil, BucketErrorResponse.invalidEmployeeCode)
            return
        }
        
        guard let retailerCode = Credentials.retailerCode, let terminalSecret = Credentials.terminalSecret else {
            completion(false, nil, BucketErrorResponse.invalidRetailer)
            return
        }
        
        guard let terminalCode = Credentials.terminalCode else {
            completion(false, nil, BucketErrorResponse.noTerminalId)
            return
        }
        
        guard let country = Credentials.retailerInfo?.country else {
            completion(false, nil, BucketErrorResponse.invalidCountryCode)
            return
        }
        
        var url = Bucket.shared.environment.url
        url.appendPathComponent("report")
        url.appendQueriesComponent(["offset": reportRequest.offset, "limit": reportRequest.limit])
        
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.addHeader("retailerCode", retailerCode)
        request.addHeader("terminalCode", terminalCode)
        request.addHeader("country", country)
        request.addHeader("x-functions-key", terminalSecret)
        if let employeeCode = reportRequest.employeeCode { request.addHeader("employeeCode", employeeCode) }
        if let eventId = reportRequest.eventId { request.addHeader("eventId", eventId) }
        
        request.setBody(reportRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(GetReportsResponse.self, from: data)
                    
                    completion(true, response, nil)
                } catch let error {
                    completion(false, nil, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, nil, bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
}

//
//  Bucket.Events.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/23/18.
//

import Foundation

extension Bucket {
    @objc public func fetchEvents(
        range: [String: Any],
        offset: Int = 0,
        limit: Int = 200,
        completion: @escaping ((_ response: GetEventsResponse?, _ success: Bool, _ error: Error?) -> Void)
        ) {
        
        // Return if the range dictionary count is invalid.
        if range.count < 1 || range.count > 2 { completion(nil, false, BucketErrorResponse.invalidDateRange); return }
        
        // Return if the id is not an integer.
        if range.count == 1 && !(range["id"] is Int) {
            // TODO: Make specific error types and messages.
            completion(nil, false, BucketErrorResponse.invalidDateRange)
            return
        }
        
        if range["start"] is String && range["end"] is String {
            // Return if start and end are both not valid dates
            if (range["start"] as! String).isNotValidStartEndDate || (range["end"] as! String).isNotValidStartEndDate {
                completion(nil, false, BucketErrorResponse.invalidDateRange)
                return
            }
        } else if !(range["start"] is Int && range["end"] is Int) {
            // Return if start and end are neither both Strings nor both Ints
            completion(nil, false, BucketErrorResponse.invalidDateRange)
            return
        }
        
        guard let retailerId = Credentials.retailerCode, let terminalSecret = Credentials.terminalSecret else {
            completion(nil, false, BucketErrorResponse.invalidRetailer)
            return
        }
        
        guard let terminalId = Credentials.terminalCode else {
            completion(nil, false, BucketErrorResponse.noTerminalId)
            return
        }
        
        guard let countryCode = Credentials.retailerInfo?.country else {
            completion(nil, false, BucketErrorResponse.invalidCountryCode)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("events").apendingQueriesComponent(["offset": offset, "limit": limit])
        var request = URLRequest(url: url)
        request.setMethod(.post)
        
        request.addHeader("retailerId", retailerId)
        request.addHeader("terminalCode", terminalId)
        request.addHeader("countryId", countryCode)
        request.addHeader("x-functions-key", terminalSecret)
        
        request.setBody(range)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(nil, false, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(GetEventsResponse.self, from: data)
                    
                    completion(response, true, nil)
                } catch let error {
                    completion(nil, false, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(nil, false, bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
}

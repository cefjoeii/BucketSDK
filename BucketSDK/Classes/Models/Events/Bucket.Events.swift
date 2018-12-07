//
//  Bucket.Events.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/23/18.
//

import Foundation

extension Bucket {
    @objc public func getEvents(
        _ getEventsRequest: GetEventsRequest,
        completion: @escaping ((_ success: Bool, _ response: GetEventsResponse?, _ canPage: Bool, _ error: Error?) -> Void)
        ) {
        
        // Some of these pitfalls should never occur unless the SDK is manually modified.
        switch getEventsRequest.range.count {
        case 1:
            if !(getEventsRequest.range["id"] is Int) {
                // Return if the id is not an Int
                completion(false, nil, true, BucketErrorResponse.eventIdDNE)
                return
            }
        case 2:
            if getEventsRequest.range["start"] is String && getEventsRequest.range["end"] is String {
                if (getEventsRequest.range["start"] as! String).isNotValidStartEndDate || (getEventsRequest.range["end"] as! String).isNotValidStartEndDate {
                    // Return if neither start nor end is a valid date.
                    completion(false, nil, true, BucketErrorResponse.invalidDateRange)
                    return
                }
            } else if !(getEventsRequest.range["start"] is Int && getEventsRequest.range["end"] is Int) {
                // Return if the start and end is neither a pair of Ints nor a pair of Strings above.
                completion(false, nil, true, BucketErrorResponse.invalidDateRange)
                return
            }
        default:
            // Return if the range dictionary count is invalid.
            completion(false, nil, true, BucketErrorResponse.invalidDateRange)
            return
        }
        
        let url = Bucket.shared.environment.url
            .appendingPathComponent("events")
            .apendingQueriesComponent(["offset": getEventsRequest.offset, "limit": getEventsRequest.limit])
        
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, true, authenticationResult.error); return }
        
        request.setMethod(.post)
        request.setBody(getEventsRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, true, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(GetEventsResponse.self, from: data)
                    
                    var canPage = true
                    
                    if let count = response.events?.count {
                        canPage = (count >= getEventsRequest.limit)
                    }
                    
                    completion(true, response, canPage, nil)
                } catch let error {
                    completion(false, nil, true, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, nil, bucketErrorResponse?.errorCode != "NoEvents", bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
    
    @objc public func getEventsReport(
        _ getEventsReportRequest: GetEventsReportRequest,
        completion: @escaping ((_ success: Bool, _ response: GetEventsReportResponse?, _ canPage: Bool, _ error: Error?) -> Void)
        ) {
        // Some of these pitfalls should never occur unless the SDK is manually modified.
        switch getEventsReportRequest.range.count {
        case 1:
            if !(getEventsReportRequest.range["id"] is Int) {
                // Return if the id is not an Int
                completion(false, nil, true, BucketErrorResponse.eventIdDNE)
                return
            }
        case 2:
            if getEventsReportRequest.range["start"] is String && getEventsReportRequest.range["end"] is String {
                if (getEventsReportRequest.range["start"] as! String).isNotValidStartEndDate || (getEventsReportRequest.range["end"] as! String).isNotValidStartEndDate {
                    // Return if neither start nor end is a valid date.
                    completion(false, nil, true, BucketErrorResponse.invalidDateRange)
                    return
                }
            } else if !(getEventsReportRequest.range["start"] is Int && getEventsReportRequest.range["end"] is Int) {
                // Return if the start and end is neither a pair of Ints nor a pair of Strings above.
                completion(false, nil, true, BucketErrorResponse.invalidDateRange)
                return
            }
        default:
            // Return if the range dictionary count is invalid.
            completion(false, nil, true, BucketErrorResponse.invalidDateRange)
            return
        }
        
        let url = Bucket.shared.environment.url
            .appendingPathComponent("report")
            .appendingPathComponent("events")
            .apendingQueriesComponent(["offset": getEventsReportRequest.offset, "limit": getEventsReportRequest.limit])
        
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, true, authenticationResult.error); return }
        
        request.setMethod(.post)
        request.setBody(getEventsReportRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, true, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(GetEventsReportResponse.self, from: data)
                    
                    var canPage = true
                    
                    if let count = response.events?.count {
                        canPage = (count >= getEventsReportRequest.limit)
                    }
                    
                    completion(true, response, canPage, nil)
                } catch let error {
                    completion(false, nil, true, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, nil, bucketErrorResponse?.errorCode != "NoEvents", bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
    
    @objc public func createEvent(
        _ createEventRequest: CreateEventRequest,
        completion: @escaping ((_ success: Bool, _ response: CreateEventResponse?, _ error: Error?) -> Void)
        ) {
        
        // Some of these pitfalls should never occur unless the SDK is manually modified.
        switch createEventRequest.range.count {
        case 2:
            if createEventRequest.range["start"] is String && createEventRequest.range["end"] is String {
                if (createEventRequest.range["start"] as! String).isNotValidStartEndDate || (createEventRequest.range["end"] as! String).isNotValidStartEndDate {
                    // Return if neither start nor end is a valid date.
                    completion(false, nil, BucketErrorResponse.invalidDateRange)
                    return
                }
            } else if !(createEventRequest.range["start"] is Int && createEventRequest.range["end"] is Int) {
                // Return if the start and end is neither a pair of Ints nor a pair of Strings above.
                completion(false, nil, BucketErrorResponse.invalidDateRange)
                return
            }
        default:
            // Return if the range dictionary count is invalid.
            completion(false, nil, BucketErrorResponse.invalidDateRange)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("event")
        
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, authenticationResult.error); return }
        
        request.setMethod(.put)
        request.setBody(createEventRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(CreateEventResponse.self, from: data)
                    
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
    
    @objc public func updateEvent(
        _ updateEventRequest: UpdateEventRequest,
        completion: @escaping ((_ success: Bool, _ response: UpdateEventResponse?, _ error: Error?) -> Void)
        ) {
        
        // Some of these pitfalls should never occur unless the SDK is manually modified.
        switch updateEventRequest.range.count {
        case 2:
            if updateEventRequest.range["start"] is String && updateEventRequest.range["end"] is String {
                if (updateEventRequest.range["start"] as! String).isNotValidStartEndDate || (updateEventRequest.range["end"] as! String).isNotValidStartEndDate {
                    // Return if neither start nor end is a valid date.
                    completion(false, nil, BucketErrorResponse.invalidDateRange)
                    return
                }
            } else if !(updateEventRequest.range["start"] is Int && updateEventRequest.range["end"] is Int) {
                // Return if the start and end is neither a pair of Ints nor a pair of Strings above.
                completion(false, nil, BucketErrorResponse.invalidDateRange)
                return
            }
        default:
            // Return if the range dictionary count is invalid.
            completion(false, nil, BucketErrorResponse.invalidDateRange)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("event")
        
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, authenticationResult.error); return }
        
        request.setMethod(.put)
        request.setBody(updateEventRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(UpdateEventResponse.self, from: data)
                    
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
    
    @objc public func deleteEvent(
        id: Int,
        completion: @escaping ((_ success: Bool, _ response: DeleteEventResponse?, _ error: Error?) -> Void)
        ) {
        
        let url = Bucket.shared.environment.url.appendingPathComponent("event").appendingPathComponent(String(id))
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, authenticationResult.error); return }
        
        request.setMethod(.delete)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(DeleteEventResponse.self, from: data)
                    
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

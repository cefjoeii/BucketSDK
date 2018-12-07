//
//  Bucket.Export.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 12/6/18.
//

import Foundation

extension Bucket {
    /// Gets the history of the past events total amounts given out.
    /// This gets sent as a CSV attachment to the specified email address.
    @objc public func exportEvents(
        _ exportEventsRequest: ExportEventsRequest,
        completion: @escaping (_ success: Bool, _ response: ExportEventsResponse?, _ error: Error?) -> Void
        ) {
        
        var url = Bucket.shared.environment.url
            .appendingPathComponent("export")
            .appendingPathComponent("events")
        
        if !exportEventsRequest.queries.isEmpty { url.appendQueriesComponent(exportEventsRequest.queries) }
        
        var request = URLRequest(url: url)
        
        let authenticationResult = request.authenticate(
            Credentials.retailerCode,
            Credentials.terminalCode,
            Credentials.country,
            Credentials.terminalSecret
        )
        
        guard authenticationResult.success else { completion(false, nil, authenticationResult.error); return }
        
        request.setMethod(.post)
        request.setBody(exportEventsRequest.body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, nil, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(ExportEventsResponse.self, from: data)
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

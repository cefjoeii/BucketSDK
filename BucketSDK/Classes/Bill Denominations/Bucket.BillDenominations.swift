//
//  Bucket.BillDenominations.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/27/18.
//

import Foundation

extension Bucket {
    /// Gathers the bill denominations for the the retailers country,
    /// in order to calculate the change using our natural change function.
    @objc public func getBillDenominations(completion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {
        guard let country = Credentials.retailerInfo?.country else {
            completion?(false, BucketErrorResponse.invalidCountryCode)
            return
        }
        
        // We will skip the API call for US.
        if country.lowercased() == "us" {
            Credentials.usesNaturalChangeFunction = true
            Credentials.denoms = [100.00, 50.00, 20.00, 10.00, 5.00, 2.00, 1.00]
            completion?(true, nil)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("billDenoms")
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.setHeaders(["country": country.lowercased()])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion?(false, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(GetBillDenominationsResponse.self, from: data)
                    
                    Credentials.usesNaturalChangeFunction = response.usesNaturalChangeFunction ?? false
                    Credentials.denoms = response.denominations ?? nil
                    
                    completion?(true, nil)
                } catch let error {
                    completion?(false, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion?(false, bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
}

//
//  Bucket.Terminal.swift
//  BucketSDK
//
//  Created by Ceferino Jose II on 11/27/18.
//

import Foundation

extension Bucket {
    /// Registers a new device with Bucket.
    /// - Parameter country: This is the **numeric** country id, or the **alpha** two letter country code.
    @objc public func registerTerminal(
        retailerCode: String,
        country: String,
        completion: @escaping (_ success: Bool, _ error: Error?) -> Void
        ) {
        
        // This device id changes whenever you uninstall and reinstall the app.
        // We save the value to the keychain only once and when it's nil.
        // The next time they uninstall and reinstall, we still have the last known value.
        if Credentials.terminalCode.isNil {
            Credentials.terminalCode = UIDevice.current.identifierForVendor!.uuidString
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("registerterminal")
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.setHeaders(["retailerCode": retailerCode, "country": country.lowercased()])
        request.setBody(["terminalCode": Credentials.terminalCode!])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(RegisterTerminalResponse.self, from: data)
                    
                    // Save the apiKey as the terminalSecret.
                    Credentials.terminalSecret = response.apiKey
                    Credentials.requireEmployeeCode = response.requireEmployeeCode ?? false
                    Credentials.retailerInfo = RetailerInfo(
                        response.retailerName,
                        response.retailerPhone,
                        response.address?.address1,
                        response.address?.address2,
                        response.address?.address3,
                        response.address?.postalCode,
                        response.address?.city,
                        response.address?.state,
                        country.lowercased()
                    )
                    
                    completion(true, nil)
                } catch let error {
                    completion(false, error)
                }
            } else {
                let bucketErrorResponse = try? JSONDecoder().decode(BucketErrorResponse.self, from: data)
                completion(false, bucketErrorResponse?.asError(response?.code) ?? BucketErrorResponse.unknown)
            }
            }.resume()
    }
}

//
//  Bucket.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

import Foundation
import Strongbox

@objc public class Bucket: NSObject {
    /// A singleton for the shared `Bucket` object.
    @objc public static let shared = Bucket()
    
    /// Sets the environment that defines which endpoint we will hit.
    @objc public dynamic var environment: DeploymentEnvironment = .development
    
    /// Registers a new device with Bucket.
    /// Make sure to set `Credentials.retailerCode` first before calling this function.
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
    
    /// Returns the amount to be bucketed based on the change due back.
    @objc public func bucketAmount(changeDueBack: Double) -> Double {
        var bucketAmount = changeDueBack
        
        var denoms = Credentials.denoms ?? []
        let usesNaturalChangeFunction = Credentials.usesNaturalChangeFunction
        
        if usesNaturalChangeFunction {
            // Make sure this is ordered by the amount.
            denoms.sort(by: >)
            // These values should already be descended from 100.0 down to 1.0
            denoms.forEach { denom in bucketAmount = bucketAmount.truncatingRemainder(dividingBy: denom) }
        } else {
            while bucketAmount > 1.00 { bucketAmount = bucketAmount.truncatingRemainder(dividingBy: 1.00) }
        }
        
        return bucketAmount
    }
}

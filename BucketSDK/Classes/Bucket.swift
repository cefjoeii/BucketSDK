//
//  Bucket.swift
//  BucketSDK
//
//  Created by Ryan Coyne on 4/6/18.
//

import Foundation
import Strongbox

@objc public class Bucket: NSObject {
    
    // Create a singleton for the Bucket object.
    @objc public static let shared = Bucket()
    
    // Set the environment that defines which endpoint we will hit for either sandbox or the production endpoint.
    @objc public dynamic var environment: DeploymentEnvironment = .development
    
    // Set our date formatter for sending the interval ids.
    fileprivate var dateFormatter = DateFormatter(format: "yyyyMMdd")
    
    private override init() {
        super.init()
        
        // Make sure our interval ids are using the UTC datestamp.
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    
    // MARK: - Bucket Functions
    /// Registers a new device with Bucket to go and create your transactions.
    /// - Parameter countryId: This is the **numeric** country id, or the **alpha** two letter country code.
    @objc public func registerTerminal(countryCode: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let retailerId = Credentials.retailerCode else {
            completion(false, BucketError.invalidRetailer)
            return
        }
        
        // This device id changes whenever you uninstall and reinstall the app.
        // We save the value to the keychain only once and when it's nil.
        // The next time they uninstall and reinstall, we still have the last known value.
        if Credentials.terminalId.isNil {
            Credentials.terminalId = UIDevice.current.identifierForVendor!.uuidString
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("registerterminal")
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.addHeader("countryId", countryCode.lowercased())
        request.addHeader("retailerId", retailerId)
        request.setBody(["terminalId": Credentials.terminalId!])
        // request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(false, error); return }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(RegisterTerminalResponse.self, from: data)
                    
                    // Save the apiKey as the terminalSecret.
                    Credentials.terminalSecret = response.apiKey
                    
                    Credentials.retailerInfo = RetailerInfo(
                        response.retailerName,
                        response.retailerPhone,
                        response.address?.address1,
                        response.address?.address2,
                        response.address?.address3,
                        response.address?.postalCode,
                        response.address?.city,
                        response.address?.state,
                        countryCode.lowercased()
                    )
                    
                    completion(true, nil)
                } catch let error {
                    completion(false, error)
                }
            } else {
                let bucketError = try? JSONDecoder().decode(BucketError.self, from: data)
                completion(false, bucketError?.asError(response?.code) ?? BucketError.unknown)
            }
            }.resume()
    }
    
    /// Gathers the bill denominations for the the retailers country, in order to calculate the change using our natural change function.
    @objc public func fetchBillDenominations(completion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {
        guard let countryCode = Credentials.retailerInfo?.countryCode else {
            completion?(false, BucketError.invalidCountryCode)
            return
        }
        
        // We think we don't have to make an API call for the US.
        if countryCode.lowercased() == "us" {
            Credentials.usesNaturalChangeFunction = true
            Credentials.denoms = [100.00, 50.00, 20.00, 10.00, 5.00, 2.00, 1.00]
            completion?(true, nil)
            return
        }
        
        let url = Bucket.shared.environment.url.appendingPathComponent("billDenoms")
        var request = URLRequest(url: url)
        request.setMethod(.post)
        request.addHeader("countryId", countryCode)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(false, error)
                return
            }
            
            if response.isSuccess {
                do {
                    // Map the json response to the model class.
                    let response = try JSONDecoder().decode(FetchBillDenominationsResponse.self, from: data)
                    
                    Credentials.usesNaturalChangeFunction = response.usesNaturalChangeFunction ?? false
                    Credentials.denoms = response.denominations ?? nil
                    
                    completion?(true, nil)
                } catch let error {
                    completion?(false, error)
                }
            } else {
                let bucketError = try? JSONDecoder().decode(BucketError.self, from: data)
                completion?(false, bucketError?.asError(response?.code) ?? BucketError.unknown)
            }
            }.resume()
    }
    
    /// Returns the amount to be bucketed based on the change due back.
    @objc public func bucketAmount(changeDueBack: Double) -> Double {
        var bucketAmount = changeDueBack
        
        // Define the precision before we do the computation.
        // Example: 0.999 should be 1.0, shouldn't it?
        // See: Unit Test
        bucketAmount.updateDecimalPlaces(to: 2)
        
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
        
        bucketAmount.updateDecimalPlaces(to: 2)
        
        return bucketAmount
    }
    
    
}

public extension Date {
    static var now: Date {
        return Date()
    }
    
    fileprivate var toYYYYMMDD: String {
        return Bucket.shared.dateFormatter.string(from: self)
    }
}

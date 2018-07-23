//
//  MainViewController.swift
//  BucketSDK
//
//  Created by Ryan on 04/06/2018.
//  Copyright (c) 2018 Ryan. All rights reserved.
//

import UIKit
import BucketSDK

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        Bucket.shared.registerDevice(with: "test123") {(success, error) in
//            print(error)
//        }
        
        //        Bucket.shared.fetchBillDenominations(for: .hkd) {(success, error) in
        //            print("error \(error?.localizedDescription!)")
        //        }
        
        //        print(Bucket.shared.bucketAmount(for: 1200))
//        Bucket.shared.close(intervalId: "542") { (response, success, error) in
//            print("response \(response?.intervalAmount)")
//            print("error \(error)")
//        }
        
//        let bucketAmount = Bucket.shared.bucketAmount(for: 1342)
//
//        let transaction = Bucket.Transaction(amount: bucketAmount, clientTransactionId: "test")
//        transaction.totalTransactionAmount = 1304
//        transaction.locationId = "asdf"
//
//        transaction.create { (response, success, error) in
//            if success {
//
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
    }
}

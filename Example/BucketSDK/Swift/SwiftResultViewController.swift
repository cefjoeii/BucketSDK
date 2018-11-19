//
//  SwiftResultViewController.swift
//  BucketSDK_Example
//
//  Created by Ceferino Jose II on 7/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import BucketSDK
import QRCode

class SwiftResultViewController: UIViewController {
    
    @IBOutlet weak var labelCustomerCode: UILabel!
    @IBOutlet weak var imageViewQRCodeContent: UIImageView!
    
    var createTransactionResponse: CreateTransactionResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCustomerCode.text = createTransactionResponse?.customerCode
        // imageViewQRCodeContent.image = QRCode((createTransactionResponse?.qrCodeContent)!)?.image
    }
}

//
//  ObjectiveCResultViewController.m
//  BucketSDK_Example
//
//  Created by Ceferino Jose II on 7/24/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "BucketSDK_Example-Swift.h"
#import "ObjectiveCResultViewController.h"

@interface ObjectiveCResultViewController ()

@end

@implementation ObjectiveCResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _labelCustomerCode.text = _createTransactionResponse.customerCode;
    _imageViewQRCodeContent.image = [QRCodeObjectiveC generateQRCodeImageWith:_createTransactionResponse.qrCodeContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

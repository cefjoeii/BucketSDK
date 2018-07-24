//
//  ObjectiveCResultViewController.h
//  BucketSDK_Example
//
//  Created by Ceferino Jose II on 7/24/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import <UIKit/UIKit.h>
@import BucketSDK;

@interface ObjectiveCResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelCustomerCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewQRCodeContent;

@property (strong, nonatomic) CreateTransactionResponse *createTransactionResponse;

@end

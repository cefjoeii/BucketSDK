//
//  ObjectiveCViewController.h
//  BucketSDK_Example
//
//  Created by Ryan Coyne on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectiveCViewController: UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldTotalSale;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCashReceived;

@end

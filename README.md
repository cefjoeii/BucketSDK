[![CI Status](http://img.shields.io/travis/buckettech/BucketSDK.svg?style=flat)](https://travis-ci.org/Ryan/BucketSDK)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/BucketSDK.svg?style=flat)](http://cocoapods.org/pods/BucketSDK)
[![License](https://img.shields.io/cocoapods/l/BucketSDK.svg?style=flat)](http://cocoapods.org/pods/BucketSDK)
[![Platform](https://img.shields.io/cocoapods/p/BucketSDK.svg?style=flat)](http://cocoapods.org/pods/BucketSDK)

# BucketSDK
This is the BucketSDK for iOS. Here is where you can create transactions and other important features of the Bucket API pre-wrapped for iOS.
Check this [video](https://www.youtube.com/watch?v=QJxjZKIDxXA) out to see the POS flow demo.

## Requirements
You will need to be registered with Bucket and have obtained a **Retailer Account**.
You will need to have received a *retailerId* and *retailerSecret* in order to access Bucket's API.

## Installation
BucketSDK is available through [CocoaPods](https://cocoapods.org/pods/BucketSDK). To install it, simply add the following line to your Podfile:
```ruby
pod 'BucketSDK'
```

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
Using the BucketSDK, you will be able to use either Swift or Objective-C to access some of the functions that you will need.

### Setting the environment
Check your app's status of being in release or debug.
This will make it easier for you as the developer to always make sure you are hitting the Sandbox API rather than the Production API.
We suggest doing this in the App Delegate launch options.
```swift
// Swift
#if RELEASE
   Bucket.shared.environment = .production
#endif
```
```objective-c
// Objective-C
#if RELEASE
    [[Bucket shared] setEnvironment:DeploymentEnvironmentProduction];
#endif
```

### Setting the retailer id and retailer secret
```swift
// Swift
Bucket.Credentials.retailerId = "RetailerId"
Bucket.Credentials.retailerSecret = "RetailerSecret"
```
```objective-c
// Objective-C
Credentials.retailerId = @"RetailerId";
Credentials.retailerSecret = @"RetailerSecret";
```

### Registering the terminal
You will need to register the terminal a.k.a device with a specified terminal id of your choice.
This terminal id will be stored when the registration is successful and will be retrieved when making transactions.
```swift
// Swift
Bucket.shared.registerDevice(with: "TERMINAL1234") { (success, error) in
    if success {
        // Yay! We have registered this device.
    } else if let error = error {
        print(error.localizedDescription)
    }
}
```

```objective-c
// Objective-C
[[Bucket shared] registerDeviceWith:@"TERMINAL1234" :^(BOOL success, NSError * _Nullable error) {
    if (success) {
        // Yay! We have registered this device.
    } else if (error != NULL) {
        NSLog(@"%@", error.localizedDescription);
    }
}];
```

### Setting your currency code
Now before using the Bucket.shared.bucketAmount(for: entireChangeAmountWithBills), you might want to set your bill denominations.
SGD (Singapore) & USD (USA) currencies are currently supported.
```swift
// Swift
Bucket.shared.fetchBillDenominations(for: .usd) { (success, error) in
    if success {
        // Yay! We have fetched the bill denominations.
        let bucketAmount = Bucket.shared.bucketAmount(for: 7899)
    } else if let error = error {
        print(error.localizedDescription)
    }
}
```
```objective-c
// Objective-C
[[Bucket shared] fetchBillDenominationsFor:BillDenominationUsd :^(BOOL success, NSError * _Nullable error) {
    if (success) {
        // Yay! We have fetched the bill denominations.
        long bucketAmount = [[Bucket shared] bucketAmountFor:7899];
    } else if (error != NULL) {
        NSLog(@"%@", error.localizedDescription);
    }
}];
```

### Getting the Bucket Amount
Another function you will use will be to calculate how much we are bucketing based on the dollar bills and change given.
Notice that we deal with the currency as an integer.
```swift
// Swift
let bucketAmount = Bucket.shared.bucketAmount(for: 7899)
```
```objective-c
// Objective-C
long bucketAmount = [[Bucket shared] bucketAmountFor:7999];
```

### Creating a transaction
Now that we have our bucket amount, we can go and create a transaction with that amount, and send it through the Bucket API.
```swift
// Swift
let transaction = Bucket.Transaction(amount: bucketAmount, clientTransactionId: "CKFYGGHPUIGH")
transaction.create { (response, success, error) in
    if success {
        // Yay! We've created the transaction.
        // The 'response' object contains the information from the transaction.
    } else if let error = error {
        print(error.localizedDescription)
    }
}
```
```objective-c
// Objective-C
Transaction *transaction = [[Transaction alloc] initWithAmount:bucketAmount clientTransactionId:@"ZDFRPHGYKOUG"];
[transaction create :^(CreateTransactionResponse * _Nullable response, BOOL success, NSError * _Nullable error) {
    if (success == YES) {
        // Yay! We've created the transaction.
        // The 'response' object contains the information from the transaction.
    } else if (error != NULL) {
        NSLog(@"%@", error.localizedDescription);
    }
}];
```

### Closing the start-to-end of day
You will need to close the interval for the start-to-end of day.
```swift
// Swift
// Close an interval.
Bucket.shared.close(intervalId: "20180422")
// Close an interval with a completion.
Bucket.shared.close(intervalId: "20180422") { (response, success, error) in
    if success {
        // Yay! We've closed the interval.
        // The 'response' object contains the information from the closing of the interval.
    }
    else if !error.isNil {
        print(error!.localizedDescription)
    }
}
```
```objective-c
// Objective-C
// Close an interval.
[[Bucket shared] closeWithIntervalId:@"20180422" :NULL];
// Close an interval with a completion.
[[Bucket shared] closeWithIntervalId:@"20180422" :^(CloseIntervalResponse * _Nullable response, BOOL success, NSError * _Nullable error) {
    if (success) {
        // Yay! We've closed the interval.
        // The 'response' object contains the information from the closing of the interval.
    } else if (error != NULL) {
        NSLog(@"%@",error.localizedDescription);
    }
}];
```

## Author

Ryan Coyne, ryan@buckettechnologies.com

## License

BucketSDK is available under the MIT license. See the LICENSE file for more info.

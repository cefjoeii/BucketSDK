# BucketSDK

[![CI Status](http://img.shields.io/travis/Ryan/BucketSDK.svg?style=flat)](https://travis-ci.org/Ryan/BucketSDK)
[![Version](https://img.shields.io/cocoapods/v/BucketSDK.svg?style=flat)](http://cocoapods.org/pods/BucketSDK)
[![License](https://img.shields.io/cocoapods/l/BucketSDK.svg?style=flat)](http://cocoapods.org/pods/BucketSDK)
[![Platform](https://img.shields.io/cocoapods/p/BucketSDK.svg?style=flat)](http://cocoapods.org/pods/BucketSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BucketSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BucketSDK'
```

## Usage
Using the BucketSDK, you will be able to use either Swift or Objective-C to access some of the functions that you will need.

### Swift Usage
```swift
// Check your app's status of being in release or debug.  This will make it easier for you as the developer to always make sure you are hitting the Sandbox API rather than the Production API.  We suggest doing this in the App Delegate launch options.
#if RELEASE
   Bucket.shared.environment = .Production
#endif

// Okay now that you set the environment, you should be able to log in with a Retailer:
Bucket.Retailer.logInWith(password: "password", username: "username") { (success, error) in
    if success {
        // Yay - we successfully logged in!
        
    } else if let error = error {
        print(error.localizedDescription)
    }
}

// Another function you will use will be to calculate how much we are bucketing based on the dollar bills and change given.  Notice that we deal with the currency as an integer:
let bucketAmount = Bucket.shared.bucketAmount(for: 7899)

// Now that we have our bucket amount, we can go and create a transaction with that amount, and send it through the Bucket API:
let transaction = Bucket.Transaction(amount: bucketAmount, clientTransactionId: "CKFYGGHPUIGH")
transaction.create { (success, error) in
    if success {
        // Yay we created the transaction!

    } else if let error = error {
        print(error.localizedDescription)
    }
}
```

### Obj-C Usage
```Objective-C
// Check your app's status of being in release or debug.  This will make it easier for you as the developer to always make sure you are hitting the Sandbox API rather than the Production API.  We suggest doing this in the App Delegate launch options.
#if RELEASE
    [Bucket.shared setEnvironment: DeploymentEnvironmentProduction];
#endif

// Okay now that you set the environment, you should be able to log in with a Retailer:
[Retailer logInWithPassword:@"password" username:@"username" :^(BOOL success, NSError * _Nullable error) {
    if (success) {
        // Yay - it was a success!!
        
    } else if (error != NULL) {
        NSLog(@"%@", error.localizedDescription);
    }
}];

// Another function you will use will be to calculate how much we are bucketing based on the dollar bills and change given.  Notice that we deal with the currency as an integer:
long bucketAmount = [[Bucket shared] bucketAmountFor:7999];

// Now that we have our bucket amount, we can go and create a transaction with that amount, and send it through the Bucket API:
Transaction *t = [[Transaction alloc] initWithAmount:bucketAmount clientTransactionId:@"ZDFRPHGYKOUG"];
[t create:^(BOOL success, NSError * _Nullable error) {
    if (success) {
        // You successfully created the transaction!

    } else if (error != NULL) {
        NSLog(@"%@", error.localizedDescription);
    }
}];
```

## Author

Ryan, ryan@buckettechnologies.com

## License

BucketSDK is available under the MIT license. See the LICENSE file for more info.

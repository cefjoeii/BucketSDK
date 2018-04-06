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

// Okay now that we are logged in, we should be able to go & create a transaction:
```

## Author

Ryan, ryan@buckettechnologies.com

## License

BucketSDK is available under the MIT license. See the LICENSE file for more info.

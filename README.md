LinioPay Tokenizer IOS SDK
===================

LinioPay Tokenizer IOS SDK allows clients to get customer’s credit card information in a secure way.

Requirements
---------------
* Ensure you have the latest version of [XCode](https://developer.apple.com/xcode/) installed.
* We encourage you to use [CocoaPods](http://cocoapods.org/) to import the SDK into your project. CocoaPods is a simple, but powerful dependency management tool. If you do not already use CocoaPods, it's very easy to [get started](http://guides.cocoapods.org/using/getting-started.html).

Setup
----------
Step 1: Add to your Podfile

```
pod 'pay-tokenizer-ios'
```

Step 2: Install

```
pod install
```

Step 3: Import

```objectivec
#import <LinioPayTokenizer/LinioPayTokenizer.h>
```

Step 4: Use your assigned merchant tokenization test and public keys respectively of your working environments to set the SDK credential key while initializing the tokenizer instance:

```objectivec
tokenizer = [[LinioPayTokenizer alloc] initWithKey:@"1234345345333"];
```

Step 5: Request a credit card token once your payment is ready to be submitted via the LinioPayTokenizer requestToken method:

```objectivec
-(void)requestToken: (NSDictionary *)formValues completion: (void (^)(NSDictionary* data, NSError* error))completion
```

Sample
----------
A sample app can be found in the [Example](/Example) folder. To run the example:

Step 1: Install Pods

```
cd Example
pod install
```

Step 2: Open Workspace

```
open LinioPayTokenizer.xcworkspace
```

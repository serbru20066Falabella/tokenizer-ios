LinioPay Tokenizer IOS SDK
===================

LinioPay Tokenizer IOS SDK allows clients to get customer’s credit card information in a secure way.

Developer Setup
---------------
* Ensure you have the latest version of [XCode](https://developer.apple.com/xcode/) installed.
* We encourage you to use [CocoaPods](http://cocoapods.org/) to import the SDK into your project. CocoaPods is a simple, but powerful dependency management tool. If you do not already use CocoaPods, it's very easy to [get started](http://guides.cocoapods.org/using/getting-started.html).

Quickstart
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
#import <pay-tokenizer-ios/BoxBrowseSDK.h>
```
Step 4: Set the Box Client ID and Client Secret that you obtain from [creating a developer account](http://developers.box.com/)
```objectivec
[BOXContentClient setClientID:@"your-client-id" clientSecret:@"your-client-secret"];
```
Step 5: Launch a BOXFolderViewController
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFolderViewController *folderViewController = [[BOXFolderViewController alloc] initWithContentClient:contentClient];

// You must push it to a UINavigationController (i.e. do not 'presentViewController')
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:folderViewController];
[self presentViewController:navigationController animated:YES completion:nil];
```

Sample App
----------
A sample app can be found in the [BoxBrowseSDKSampleApp](../../tree/master/BoxBrowseSDKSampleApp) folder. To execute the sample app:
Step 1: Install Pods
```
cd BoxBrowseSDKSampleApp
pod install
```
Step 2: Open Workspace
```
open BoxBrowseSDKSampleApp.xcworkspace
```

Contributing
------------
See [CONTRIBUTING](CONTRIBUTING.md) on how to help out.


Copyright and License
---------------------
Copyright 2015 Box, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

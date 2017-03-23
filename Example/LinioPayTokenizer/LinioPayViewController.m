//
//  linioPayViewController.m
//  LinioPayTokenizer
//
//  Created by omargon on 03/14/2017.
//  Copyright (c) 2017 omargon. All rights reserved.
//

#import "LinioPayViewController.h"
#import "LinioPayTokenizer.h"

@interface LinioPayViewController()

@property (nonatomic, readonly) LinioPayTokenizer *tokenizer;

@end

@implementation LinioPayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    _tokenizer = [[LinioPayTokenizer alloc] initWithKey:@"test_0618f5c21603cd9d33ba8a8f0c9e2446283"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitForm:(id)sender
{
    [self makeRequest];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self resignFirstResponder];
}

- (void)makeRequest
{
    NSLog(@"Submitting form");
    [_tokenizer requestToken:
     @{
       @"cardholder": nameField.text,
       @"number": numberField.text,
       @"cvc": cvcField.text,
       @"expiration_month": monthField.text,
       @"expiration_year": yearField.text,
       @"address": @{
               @"street1": addressLine1Field.text,
               @"street2": addressLine2Field.text,
               @"city": addressCityField.text,
               @"state": addressStateField.text,
               @"country_code": addressCountryCodeField.text,
               @"postal_code": addressPostalCodeField.text,
               },
       }
    completion: ^(NSDictionary *data, NSError *error)
    {
        NSMutableString *message = [[NSMutableString alloc] init];
        if(error!=nil)
        {
            message = [NSMutableString stringWithFormat:@"%@", [error userInfo]];
        }
        else
        {
            message = [NSMutableString stringWithFormat:@"%@", data];
        }

        dispatch_async(dispatch_get_main_queue(),
        ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tokenizer Response"
                                                            message:[NSString stringWithFormat:@"%@", message]
                                                           delegate:nil cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        });
    }];
}

@end

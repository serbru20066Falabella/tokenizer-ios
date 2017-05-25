//
//  linioPayViewController.h
//  LinioPayTokenizer
//
//  Created by omargon on 03/14/2017.
//  Copyright (c) 2017 omargon. All rights reserved.
//

@import UIKit;

@interface LinioPayViewController : UIViewController{

    IBOutlet UITextField *nameField;
    IBOutlet UITextField *numberField;
    IBOutlet UITextField *cvcField;
    IBOutlet UITextField *monthField;
    IBOutlet UITextField *yearField;
    IBOutlet UITextField *addressLine1Field;
    IBOutlet UITextField *addressLine2Field;
    IBOutlet UITextField *addressCityField;
    IBOutlet UITextField *addressStateField;
    IBOutlet UITextField *addressCountryField;
    IBOutlet UITextField *addressPostalCodeField;

}

- (IBAction)submitForm:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

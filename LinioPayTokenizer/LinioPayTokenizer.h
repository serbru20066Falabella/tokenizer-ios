//
//  LinioPayTokenizer.h
//  pay-tokenizer-ios
//
//  Created by Omar on 3/3/17.
//  Copyright © 2017 omargon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinioPayTokenizer : NSObject

extern const NSString *FORM_DICT_KEY_NAME;
extern const NSString *FORM_DICT_KEY_NUMBER;
extern const NSString *FORM_DICT_KEY_CVC;
extern const NSString *FORM_DICT_KEY_MONTH;
extern const NSString *FORM_DICT_KEY_YEAR;
extern const NSString *FORM_DICT_KEY_ADDRESS;
extern const NSString *FORM_DICT_KEY_STREET_1;
extern const NSString *FORM_DICT_KEY_STREET_2;
extern const NSString *FORM_DICT_KEY_CITY;
extern const NSString *FORM_DICT_KEY_STATE;
extern const NSString *FORM_DICT_KEY_COUNTRY_CODE;
extern const NSString *FORM_DICT_KEY_POSTAL_CODE;

- (id)initWithKey:(NSString *)key;
- (BOOL)validateKey:(NSString *)key;
- (BOOL)validateName:(NSString*)name;
- (BOOL)validateNumber:(NSString *)cardNumber;
- (BOOL)validateCVC:(NSString *)cvcNumber card:(NSString *)cardNumber;
- (BOOL)validateExpDate:(NSString *)monthValue year:(NSString *)yearValue;
- (BOOL)validateAddressStreet1:(NSString *)addressStreet1;
- (BOOL)validateAddressStreet2:(NSString *)addressStreet2;
- (BOOL)validateAddressCity:(NSString *)city;
- (BOOL)validateAddressState:(NSString *)state;
- (BOOL)validateAddressCountryCode:(NSString *)countryCode;
- (BOOL)validateAddressPostalCode:(NSString *)postalCode;
- (void)requestToken:(NSDictionary *)formValues completion:(void (^)(NSDictionary* data, NSError* error))completion;

@end

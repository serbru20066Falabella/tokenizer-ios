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
- (void)validateKey:(NSString *)key completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateName:(NSString*)name completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateNumber:(NSString *)cardNumber completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateCVC:(NSString *)cvcNumber card:(NSString *)cardNumber completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateExpDate:(NSString *)monthValue year:(NSString *)yearValue completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateAddressStreet1:(NSString *)addressStreet1 completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateAddressStreet2:(NSString *)addressStreet2 completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateAddressCity:(NSString *)city completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateAddressState:(NSString *)state completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateAddressCountryCode:(NSString *)countryCode completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)validateAddressPostalCode:(NSString *)postalCode completion:(void (^) (BOOL success, NSError *error)) completion;
- (void)requestToken:(NSDictionary *)formValues completion:(void (^)(NSDictionary* data, NSError* error))completion;

@end

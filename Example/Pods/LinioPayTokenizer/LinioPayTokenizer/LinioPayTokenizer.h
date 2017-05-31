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
extern const NSString *FORM_DICT_KEY_COUNTRY;
extern const NSString *FORM_DICT_KEY_POSTAL_CODE;

- (id)initWithKey:(NSString *)key;
- (BOOL)validateKey:(NSString *)key error:(NSError **)outError;
- (BOOL)validateName:(NSString*)name error:(NSError **)outError;
- (BOOL)validateNumber:(NSString *)cardNumber error:(NSError **)outError;
- (BOOL)validateCVC:(NSString *)cvcNumber card:(NSString *)cardNumber error:(NSError **)outError;
- (BOOL)validateExpDate:(NSString *)monthValue year:(NSString *)yearValue error:(NSError **)outError;
- (BOOL)validateAddressStreet1:(NSString *)addressStreet1 error:(NSError **)outError;
- (BOOL)validateAddressStreet2:(NSString *)addressStreet2 error:(NSError **)outError;
- (BOOL)validateAddressCity:(NSString *)city error:(NSError **)outError;
- (BOOL)validateAddressState:(NSString *)state error:(NSError **)outError;
- (BOOL)validateAddressCountry:(NSString *)country error:(NSError **)outError;
- (BOOL)validateAddressPostalCode:(NSString *)postalCode error:(NSError **)outError;
- (void)requestToken:(NSDictionary *)formValues completion:(void (^)(NSDictionary* data, NSError* error))completion;

@end

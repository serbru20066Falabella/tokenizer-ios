//
//  LinioPayTokenizer.m
//  pay-tokenizer-ios
//
//  Created by Omar on 3/3/17.
//  Copyright © 2017 omargon. All rights reserved.
//

#import "LinioPayTokenizer.h"
#import "LinioPayTokenizerConstants.h"

@interface LinioPayTokenizer ()

@property (nonatomic, readwrite, strong) NSString *tokenizationKey;
@property (nonatomic, readwrite, strong) NSMutableArray *errorMessages;

@end

@implementation LinioPayTokenizer

-(id)initWithKey:(NSString *)key
{
    self = [super init];
    
    _errorMessages = [NSMutableArray arrayWithCapacity:1];
    
    if(self)
    {
        _tokenizationKey = key;
    }
    
    return self;
}

-(BOOL)validateKey:(NSString *)key
{
    const NSUInteger keyCharLength = CHAR_LENGTH_KEY;
    
    const NSError *requiredError = [NSError errorWithDomain:ERROR_DOMAIN
                                                       code:ERROR_CODE_REQUIRED_KEY
                                                   userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_KEY }];
    
    const NSError *invalidError = [NSError errorWithDomain:ERROR_DOMAIN
                                                      code:ERROR_CODE_INVALID_KEY
                                                  userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_INVALID_KEY }];
    
    NSString *regEx = [NSString stringWithFormat:@"^\\w{%lu}$", (unsigned long)keyCharLength];
    
    if (key == nil)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    NSMutableString *formattedKey = [NSMutableString stringWithString:key];
    formattedKey = [self trimString:formattedKey];
    
    if ([formattedKey length] == 0)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    if (![self testRegExp:formattedKey withPattern:regEx])
    {
        [_errorMessages addObject:invalidError];
        return false;
    }
    
    return true;
}

-(BOOL)validateName:(NSString *)name
{
    const NSUInteger minCharacters = MIN_CHAR_NAME;
    const NSUInteger maxCharacters = MAX_CHAR_NAME;

    const NSError *requiredError = [NSError errorWithDomain:ERROR_DOMAIN
                                                       code:ERROR_CODE_REQUIRED_NAME
                                                   userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_NAME }];
    
    const NSError *charMinLimitError = [NSError errorWithDomain:ERROR_DOMAIN
                                                           code:ERROR_CODE_CHAR_MIN_LIMIT_NAME
                                                       userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:ERROR_DESC_CHAR_MIN_LIMIT_NAME, (unsigned long)minCharacters] }];
    
    const NSError *charMaxLimitError = [NSError errorWithDomain:ERROR_DOMAIN
                                                           code:ERROR_CODE_CHAR_MAX_LIMIT_NAME
                                                       userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:ERROR_DESC_CHAR_MAX_LIMIT_NAME, (unsigned long)maxCharacters] }];
    
    if (name == nil)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    NSMutableString *formattedName = [self trimString:[NSMutableString stringWithString:name]];
    
    if ([formattedName length] == 0)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    if ([formattedName length] < minCharacters)
    {
        [_errorMessages addObject:charMinLimitError];
        return false;
    }
    
    if ([formattedName length] > maxCharacters) {
        [_errorMessages addObject:charMaxLimitError];
        return false;
    }
    
    return true;
}

-(BOOL)validateNumber:(NSString *)cardNumber
{
    const NSError *requiredError = [NSError errorWithDomain:ERROR_DOMAIN
                                                       code:ERROR_CODE_REQUIRED_CARD_NUMBER
                                                   userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_CARD_NUMBER }];
    
    const NSError *invalidError = [NSError errorWithDomain:ERROR_DOMAIN
                                                      code:ERROR_CODE_INVALID_CARD_NUMBER
                                                  userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_INVALID_CARD_NUMBER }];
    
    const NSError *error = nil;
    const NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"\\s|-"
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
    
    if (cardNumber == nil)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    NSString *modifiedCardNumber = [regEx stringByReplacingMatchesInString:cardNumber
                                                                   options:0
                                                                     range:NSMakeRange(0, [cardNumber length])
                                                              withTemplate:@""];
    
    if ([modifiedCardNumber length] == 0)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    // accept only digits after removing dashes or spaces
    
    if([self testRegExp:modifiedCardNumber withPattern:@"^\\d+$"] == 0)
    {
        [_errorMessages addObject:invalidError];
        return false;
    }
    
    // Luhn Check
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[modifiedCardNumber length]];
    
    [cardNumber enumerateSubstringsInRange:NSMakeRange(0, [modifiedCardNumber length])
                                   options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences)
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {
        [reversedString appendString:substring];
    }];
    
    NSUInteger oddSum = 0, evenSum = 0;
    
    for (NSUInteger i = 0; i < [reversedString length]; i++)
    {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        
        if (i % 2 == 0)
        {
            evenSum += digit;
        }
        else
        {
            oddSum += digit / 5 + (2 * digit) % 10;
        }
    }
    
    if ((oddSum + evenSum) % 10 != 0)
    {
        [_errorMessages addObject:invalidError];
        return false;
    }
    
    return true;
}

-(BOOL)validateCVC:(NSString *)cvcNumber card:(NSString *)cardNumber
{
    // Field is optional
    if (cvcNumber != nil)
    {
        const NSError *invalidError = [NSError errorWithDomain:ERROR_DOMAIN
                                                          code:ERROR_CODE_INVALID_CVC
                                                      userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_INVALID_CVC }];
        
        NSInteger validCVCNumberLength = CHAR_LENGTH_CVC;
        
        NSMutableString *formattedCVC = [NSMutableString stringWithString:cvcNumber];
        formattedCVC = [self trimString:formattedCVC];
        
        NSMutableString *formattedCardNumber = [NSMutableString stringWithString:cardNumber];
        formattedCardNumber = [self trimString:formattedCardNumber];
        
        // If card Type Amex expect 4 digits CVC number
        
        if ([self testRegExp:formattedCardNumber withPattern:@"^3[47]"])
        {
            validCVCNumberLength = CHAR_LENGTH_CVC_AMEX;
        }
        
        
        if (![self testRegExp:formattedCVC withPattern:[NSString stringWithFormat:@"^\\d{%lu}$", (long)validCVCNumberLength]])
        {
            [_errorMessages addObject:invalidError];
            return false;
        }
    }
    return true;
}

-(BOOL)validateExpDate:(NSString *)monthValue year:(NSString *)yearValue
{
    const NSError *requiredMonthError = [NSError errorWithDomain:ERROR_DOMAIN
                                                            code:ERROR_CODE_REQUIRED_MONTH
                                                        userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_MONTH }];
    
    const NSError *invalidMonthError = [NSError errorWithDomain:ERROR_DOMAIN
                                                           code:ERROR_CODE_INVALID_MONTH
                                                       userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_INVALID_MONTH }];
    
    const NSError *requiredYearError = [NSError errorWithDomain:ERROR_DOMAIN
                                                           code:ERROR_CODE_REQUIRED_YEAR
                                                       userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_YEAR }];
    
    const NSError *invalidYearError = [NSError errorWithDomain:ERROR_DOMAIN
                                                          code:ERROR_CODE_INVALID_YEAR
                                                      userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_INVALID_YEAR }];
    
    const NSError *invalidExpError = [NSError errorWithDomain:ERROR_DOMAIN
                                                         code:ERROR_CODE_INVALID_EXPIRATION
                                                     userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_INVALID_EXPIRATION }];
    
    BOOL missingData = false, invalidData = false;
    
    if (monthValue == nil)
    {
        [_errorMessages addObject:requiredMonthError];
        missingData = true;
    }
    
    if (yearValue == nil)
    {
        [_errorMessages addObject:requiredYearError];
        missingData = true;
    }
    
    if (missingData)
    {
        return false;
    }
    
    NSString *formattedMonth = [self trimString:[NSMutableString stringWithString:monthValue]];
    
    NSString *formattedYear = [self trimString:[NSMutableString stringWithString:yearValue]];
    
    if ([formattedMonth length] == 0)
    {
        [_errorMessages addObject:requiredMonthError];
        missingData = true;
    }
    
    if ([formattedYear length] == 0)
    {
        [_errorMessages addObject:requiredYearError];
        missingData = true;
    }
    
    if (missingData) {
        return false;
    }
    
    if (![self testRegExp:formattedMonth withPattern:@"^\\d{1,2}$"])
    {
        [_errorMessages addObject:invalidMonthError];
        invalidData = true;
    }
    
    if (![self testRegExp:formattedYear withPattern:@"^\\d{4}$"])
    {
        [_errorMessages addObject:invalidYearError];
        invalidData = true;
    }
    
    if (invalidData) {
        return false;
    }
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    
    NSDate *expirationDate =[dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@", formattedYear, formattedMonth]];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    expirationDate = [calendar dateByAddingComponents:dateComponents toDate:expirationDate options:0];
    
    if ([expirationDate compare:today] == NSOrderedAscending)
    {
        [_errorMessages addObject:invalidExpError];
        return false;
    }
    
    return true;
}

-(BOOL)validateAddressStreet1:(NSString *)addressStreet1
{
    const NSUInteger maxCharacters = MAX_CHAR_STREET_1;
    
    const NSError *requiredError = [NSError errorWithDomain:ERROR_DOMAIN
                                                       code:ERROR_CODE_REQUIRED_STREET_1
                                                   userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_STREET_1 }];
    
    const NSError *charMaxLimitError = [NSError errorWithDomain:ERROR_DOMAIN
                                                           code:ERROR_CODE_CHAR_MAX_LIMIT_STREET_1
                                                       userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:ERROR_DESC_CHAR_MAX_LIMIT_STREET_1, (unsigned long)maxCharacters] }];
    
    if (addressStreet1 == nil)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    NSString *formattedAddressStreet1 = [self trimString:[NSMutableString stringWithString:addressStreet1]];
    
    if ([formattedAddressStreet1 length] == 0)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    if ([formattedAddressStreet1 length] > maxCharacters)
    {
        [_errorMessages addObject:charMaxLimitError];
        return false;
    }
    return true;
}

-(BOOL)validateAddressStreet2:(NSString *)addressStreet2
{
    // Always optional
    if (addressStreet2 != nil)
    {
        const NSUInteger maxCharacters = MAX_CHAR_STREET_2;
        const NSError *charMaxLimitError = [NSError errorWithDomain:ERROR_DOMAIN
                                                               code:ERROR_CODE_CHAR_MAX_LIMIT_STREET_2
                                                           userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:ERROR_DESC_CHAR_MAX_LIMIT_STREET_2, (unsigned long)maxCharacters] }];
        
        NSString *formattedAddressStreet2 = [self trimString:[NSMutableString stringWithString:addressStreet2]];
        
        if ([formattedAddressStreet2 length] > maxCharacters)
        {
            [_errorMessages addObject:charMaxLimitError];
            return false;
        }
    }
    
    return true;
}

-(BOOL)validateAddressCity:(NSString *)city
{
    const NSUInteger maxCharacters = MAX_CHAR_CITY;
    
    const NSError *requiredError = [NSError errorWithDomain:ERROR_DOMAIN
                                                       code:ERROR_CODE_REQUIRED_CITY
                                                   userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_CITY }];
    
    const NSError *charMaxLimitError = [NSError errorWithDomain:ERROR_DOMAIN
                                                           code:ERROR_CODE_CHAR_MAX_LIMIT_CITY
                                                       userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:ERROR_DESC_CHAR_MAX_LIMIT_CITY, (unsigned long)maxCharacters] }];

    if (city == nil)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    NSString *formattedCity = [self trimString:[NSMutableString stringWithString:city]];
    
    if ([formattedCity length] == 0)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    if ([formattedCity length] > maxCharacters)
    {
        [_errorMessages addObject:charMaxLimitError];
        return false;
    }
    
    return true;
}

-(BOOL)validateAddressState:(NSString *)state
{
    const NSUInteger maxCharacters = MAX_CHAR_STATE;
    
    const NSError *requiredError = [NSError errorWithDomain:ERROR_DOMAIN
                                                       code:ERROR_CODE_REQUIRED_STATE
                                                   userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_STATE }];
    
    const NSError *charMaxLimitError = [NSError errorWithDomain:ERROR_DOMAIN
                                                           code:ERROR_CODE_CHAR_MAX_LIMIT_STATE
                                                       userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:ERROR_DESC_CHAR_MAX_LIMIT_STATE, (unsigned long)maxCharacters] }];
   
    if (state == nil)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    NSString *formattedState = [self trimString:[NSMutableString stringWithString:state]];
    
    if ([formattedState length] == 0)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    if ([formattedState length] > maxCharacters)
    {
        [_errorMessages addObject:charMaxLimitError];
        return false;
    }
    
    return true;
}

-(BOOL)validateAddressCountryCode:(NSString *)countryCode
{
    const NSUInteger numberOfCharacters = CHAR_LENGTH_COUNTRY_CODE;
    
    const NSError *requiredError = [NSError errorWithDomain:ERROR_DOMAIN
                                                       code:ERROR_CODE_REQUIRED_COUNTRY_CODE
                                                   userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_COUNTRY_CODE }];

    const NSError *invalidError = [NSError errorWithDomain:ERROR_DOMAIN
                                                         code:ERROR_CODE_INVALID_COUNTRY_CODE
                                                     userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_INVALID_COUNTRY_CODE }];
    
    if (countryCode == nil)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    NSString *formattedCountryCode = [self trimString:[NSMutableString stringWithString:countryCode]];
    
    if ([formattedCountryCode length] == 0)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    if ([self testRegExp:formattedCountryCode withPattern:[NSString stringWithFormat:@"^[A-Za-z]{%lu}$", (unsigned long)numberOfCharacters]] == 0)
    {
        [_errorMessages addObject:invalidError];
        return false;
    }
    
    return true;
}

-(BOOL)validateAddressPostalCode:(NSString *)postalCode
{
    const NSUInteger maxCharacters = MAX_CHAR_POSTAL_CODE;
    
    const NSError *requiredError = [NSError errorWithDomain:ERROR_DOMAIN
                                                       code:ERROR_CODE_REQUIRED_POSTAL_CODE
                                                   userInfo:@{ NSLocalizedDescriptionKey : ERROR_DESC_REQUIRED_POSTAL_CODE }];
    
    const NSError *charMaxLimitError = [NSError errorWithDomain:ERROR_DOMAIN
                                                           code:ERROR_CODE_CHAR_MAX_LIMIT_POSTAL_CODE
                                                       userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:ERROR_DESC_CHAR_MAX_LIMIT_POSTAL_CODE, (unsigned long)maxCharacters] }];
    
    if (postalCode == nil)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    NSString *formattedPostalCode = [self trimString:[NSMutableString stringWithString:postalCode]];
    
    if ([formattedPostalCode length] == 0)
    {
        [_errorMessages addObject:requiredError];
        return false;
    }
    
    if ([formattedPostalCode length] > maxCharacters)
    {
        [_errorMessages addObject:charMaxLimitError];
        return false;
    }
    
    return true;
}

-(NSMutableString *)trimString:(NSMutableString *)string
{
    const NSError *error = nil;
    const NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\s+|\\s+$"
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
    
    const NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"\\s+"
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error];
    
    NSMutableString *modifiedString = [NSMutableString stringWithString:[regex stringByReplacingMatchesInString:string
                                                                                                        options:0
                                                                                                          range:NSMakeRange(0, [string length])
                                                                                                   withTemplate:@""]];
    
    modifiedString = [NSMutableString stringWithString:[regex2 stringByReplacingMatchesInString:modifiedString
                                                                                        options:0 range:NSMakeRange(0, [modifiedString length])
                                                                                   withTemplate:@" "]];
    
    return modifiedString;
}

-(BOOL)testRegExp:(NSString *)string withPattern:(NSString *) pattern
{
    const NSError *error = nil;
    const NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
    
    if ([regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])] > 0)
    {
        return true;
    }
    
    return false;
}

-(void)requestToken:(NSDictionary *)formValues completion:(void (^) (NSDictionary *, NSError *)) completion
{
    _errorMessages = [NSMutableArray arrayWithCapacity:1];
    
    [self validateKey:_tokenizationKey];
    [self validateName:[formValues objectForKey:@"cardholder"]];
    [self validateNumber:[formValues objectForKey:@"number"]];
    [self validateCVC:[formValues objectForKey:@"cvc"]  card:[formValues objectForKey:@"number"]];
    [self validateExpDate:[formValues objectForKey:@"expiration_month"] year:[formValues objectForKey:@"expiration_year"]];
    if ([formValues objectForKey:@"address"] != nil)
    {
        NSDictionary *addressData = [formValues objectForKey:@"address"];
        [self validateAddressStreet1:[addressData objectForKey:@"street1"]];
        [self validateAddressStreet2:[addressData objectForKey:@"street2"]];
        [self validateAddressCity:[addressData objectForKey:@"city"]];
        [self validateAddressState:[addressData objectForKey:@"state"]];
        [self validateAddressCountryCode:[addressData objectForKey:@"country_code"]];
        [self validateAddressPostalCode:[addressData objectForKey:@"postal_code"]];
    }
    
    if ([_errorMessages count] > 0)
    {
        id objectInstance;
        NSUInteger indexKey = 0;
        NSMutableDictionary *errorsDictionary = [[NSMutableDictionary alloc] init];
        
        for (objectInstance in _errorMessages)
        {
            [errorsDictionary setObject:objectInstance
                                 forKey:[NSString stringWithFormat:@"Error-%lu", (unsigned long)indexKey++]];
        }
        
        completion(nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:errorsDictionary]);
    }
    else
    {
        NSDictionary *postData =@{
                                  @"tokenization_key": _tokenizationKey,
                                  @"token": @{
                                          @"one_time": @"false",
                                          @"payment_method": @{
                                                  @"charge_card": formValues,
                                                  },
                                          },
                                  };
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData
                                                           options:(NSJSONWritingOptions)0
                                                             error:&error];
        
        if (!jsonData)
        {
            NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", [error localizedDescription]);
            completion(nil, [NSError errorWithDomain:NSURLErrorDomain
                                                code:0
                                            userInfo:@{@"Error message": @"JSON error"}]);
        }
        
        // Else submit form
        
        NSURL * apiURL = [NSURL URLWithString:LPTS_API_PATH];
        
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
        
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:jsonData];

        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                     delegate:nil
                                                                delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error!=nil)
            {
                completion(nil,error);
            }
            else
            {
                NSError* jsonError;
                NSDictionary* results = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:&jsonError];
                 
                if(jsonError!=nil)
                {
                    completion(nil,jsonError);
                }
                else
                {
                    completion(results,nil);
                }
            }
        }];
        
        [dataTask resume];
    }
}

@end

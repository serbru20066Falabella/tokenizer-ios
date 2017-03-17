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
    const NSString *requiredAlert = @"Tokenization key is required";
    const NSString *invalidAlert = @"Tokenization key is invalid";
    const NSInteger validkeyLength = 40;
    NSString *regEx = [NSString stringWithFormat:@"^\\w{%lu}$", (unsigned long)validkeyLength];
    
    if (key == nil)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    NSMutableString *formattedKey = [NSMutableString stringWithString:key];
    formattedKey = [self trimString:formattedKey];
    
    if ([formattedKey length] == 0)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    if (![self testRegExp:formattedKey withPattern:regEx])
    {
        [_errorMessages addObject:invalidAlert];
        return false;
    }
    
    return true;
}

-(BOOL)validateName:(NSString *)name
{
    const NSUInteger minCharacters = 5;
    const NSUInteger maxCharacters = 60;
    const NSString *requiredAlert = @"Card holder name is required";
    const NSString *invalidAlert = @"Invalid card holder name";
    const NSString *maxAlert = [NSString stringWithFormat:@"Card holder name should have less than %lu characters", (unsigned long)maxCharacters];
    
    if (name == nil)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    NSMutableString *formattedName = [self trimString:[NSMutableString stringWithString:name]];
    
    if ([formattedName length] == 0)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    if ([formattedName length] < minCharacters)
    {
        [_errorMessages addObject:invalidAlert];
        return false;
    }
    
    if ([formattedName length] > maxCharacters) {
        [_errorMessages addObject:maxAlert];
        return false;
    }
    
    return true;
}

-(BOOL)validateNumber:(NSString *)cardNumber
{
    const NSString *requiredAlert = @"Credit card number is required";
    const NSString *invalidAlert = @"Invalid credit card number";
    const NSError *error = nil;
    const NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"\\s|-"
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
    
    if (cardNumber == nil)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    NSString *modifiedCardNumber = [regEx stringByReplacingMatchesInString:cardNumber
                                                                   options:0
                                                                     range:NSMakeRange(0, [cardNumber length])
                                                              withTemplate:@""];
    
    if ([modifiedCardNumber length] == 0)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    // accept only digits after removing dashes or spaces
    
    if([self testRegExp:modifiedCardNumber withPattern:@"^\\d+$"] == 0)
    {
        [_errorMessages addObject:invalidAlert];
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
        [_errorMessages addObject:invalidAlert];
        return false;
    }
    
    return true;
}

-(BOOL)validateCVC:(NSString *)cvcNumber card:(NSString *)cardNumber
{
    // Field is optional
    if (cvcNumber != nil)
    {
        
        const NSString *invalidAlert = @"Invalid CVC number";
        const NSInteger cardCVCLength = 3;
        const NSInteger amexCardCVCLength = 4;
        
        NSInteger validCVCNumberLength = cardCVCLength;
        
        NSMutableString *formattedCVC = [NSMutableString stringWithString:cvcNumber];
        formattedCVC = [self trimString:formattedCVC];
        
        NSMutableString *formattedCardNumber = [NSMutableString stringWithString:cardNumber];
        formattedCardNumber = [self trimString:formattedCardNumber];
        
        // If card Type Amex expect 4 digits CVC number
        
        if ([self testRegExp:formattedCardNumber withPattern:@"^3[47]"])
        {
            validCVCNumberLength = amexCardCVCLength;
        }
        
        
        if (![self testRegExp:formattedCVC withPattern:[NSString stringWithFormat:@"^\\d{%lu}$", (long)validCVCNumberLength]])
        {
            [_errorMessages addObject:invalidAlert];
            return false;
        }
    }
    return true;
}

-(BOOL)validateExpDate:(NSString *)monthValue year:(NSString *)yearValue
{
    const NSString *requiredMonthAlert = @"Expiration month is required";
    const NSString *requiredYearAlert = @"Expiration year is required";
    const NSString *invalidAlert = @"Invalid expiration date";
    
    BOOL missingData = false;
    
    if (monthValue == nil)
    {
        [_errorMessages addObject:requiredMonthAlert];
        missingData = true;
    }
    
    if (yearValue == nil)
    {
        [_errorMessages addObject:requiredYearAlert];
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
        [_errorMessages addObject:requiredMonthAlert];
        missingData = true;
    }
    
    if ([formattedYear length] == 0)
    {
        [_errorMessages addObject:requiredYearAlert];
        missingData = true;
    }
    
    if (missingData) {
        return false;
    }
    
    if (![self testRegExp:formattedMonth withPattern:@"^\\d{1,2}$"] || ![self testRegExp:formattedYear withPattern:@"^\\d{4}$"])
    {
        [_errorMessages addObject:invalidAlert];
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
        [_errorMessages addObject:invalidAlert];
        return false;
    }
    
    return true;
}

-(BOOL)validateAddressStreet1:(NSString *)addressStreet1
{
    const NSUInteger maxCharacters = 255;
    const NSString *requiredAlert = @"Address street 1 is required";
    const NSString *maxAlert = [NSString stringWithFormat:@"Address street 1 value should have less than %lu characters", (unsigned long)maxCharacters];
    
    if (addressStreet1 == nil)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    NSString *formattedAddressStreet1 = [self trimString:[NSMutableString stringWithString:addressStreet1]];
    
    if ([formattedAddressStreet1 length] == 0)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    if ([formattedAddressStreet1 length] > maxCharacters)
    {
        [_errorMessages addObject:maxAlert];
        return false;
    }
    return true;
}

-(BOOL)validateAddressStreet2:(NSString *)addressStreet2
{
    // Always optional
    if (addressStreet2 != nil)
    {
        const NSUInteger maxCharacters = 255;
        const NSString *maxAlert = [NSString stringWithFormat:@"Address street 2 value should have less than %lu characters", (unsigned long)maxCharacters];
        
        NSString *formattedAddressStreet2 = [self trimString:[NSMutableString stringWithString:addressStreet2]];
        
        if ([formattedAddressStreet2 length] > maxCharacters)
        {
            [_errorMessages addObject:maxAlert];
            return false;
        }
    }
    
    return true;
}

-(BOOL)validateAddressCity:(NSString *)city
{
    const NSUInteger maxCharacters = 255;
    const NSString *requiredAlert = @"City value is required";
    const NSString *maxAlert = [NSString stringWithFormat:@"City value should have less than %lu characters", (unsigned long)maxCharacters];
    
    if (city == nil)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    NSString *formattedCity = [self trimString:[NSMutableString stringWithString:city]];
    
    if ([formattedCity length] == 0)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    if ([formattedCity length] > maxCharacters)
    {
        [_errorMessages addObject:maxAlert];
        return false;
    }
    
    return true;
}

-(BOOL)validateAddressState:(NSString *)state
{
    const NSUInteger maxCharacters = 120;
    const NSString *requiredAlert = @"State value is required";
    const NSString *maxAlert = [NSString stringWithFormat:@"State value should have less than %lu characters", (unsigned long)maxCharacters];
    
    if (state == nil)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    NSString *formattedState = [self trimString:[NSMutableString stringWithString:state]];
    
    if ([formattedState length] == 0)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    if ([formattedState length] > maxCharacters)
    {
        [_errorMessages addObject:maxAlert];
        return false;
    }
    
    return true;
}

-(BOOL)validateAddressCountryCode:(NSString *)countryCode
{
    const NSUInteger numberOfCharacters = 3;
    const NSString *requiredAlert = @"Country code value is required";
    const NSString *invalidAlert = [NSString stringWithFormat:@"Country code value should contain %lu alpha characters", (unsigned long)numberOfCharacters];
    
    if (countryCode == nil)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    NSString *formattedCountryCode = [self trimString:[NSMutableString stringWithString:countryCode]];
    
    if ([formattedCountryCode length] == 0)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    if ([self testRegExp:formattedCountryCode withPattern:[NSString stringWithFormat:@"^[A-Za-z]{%lu}$", (unsigned long)numberOfCharacters]] == 0)
    {
        [_errorMessages addObject:invalidAlert];
        return false;
    }
    
    return true;
}

-(BOOL)validateAddressPostalCode:(NSString *)postalCode
{
    const NSUInteger maxCharacters = 20;
    const NSString *requiredAlert = @"Postal code is required";
    const NSString *maxAlert = [NSString stringWithFormat:@"Postal code value should have less than %lu characters", (unsigned long)maxCharacters];
    
    if (postalCode == nil)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    NSString *formattedPostalCode = [self trimString:[NSMutableString stringWithString:postalCode]];
    
    if ([formattedPostalCode length] == 0)
    {
        [_errorMessages addObject:requiredAlert];
        return false;
    }
    
    if ([formattedPostalCode length] > maxCharacters)
    {
        [_errorMessages addObject:maxAlert];
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
    [self validateName:[formValues objectForKey:@"name"]];
    [self validateNumber:[formValues objectForKey:@"number"]];
    [self validateCVC:[formValues objectForKey:@"cvc"]  card:[formValues objectForKey:@"number"]];
    [self validateExpDate:[formValues objectForKey:@"month"] year:[formValues objectForKey:@"year"]];
    if ([formValues objectForKey:@"address"] != nil)
    {
        NSDictionary *addressData = [formValues objectForKey:@"address"];
        [self validateAddressStreet1:[addressData objectForKey:@"addressStreet1"]];
        [self validateAddressStreet2:[addressData objectForKey:@"addressStreet2"]];
        [self validateAddressCity:[addressData objectForKey:@"addressCity"]];
        [self validateAddressState:[addressData objectForKey:@"addressState"]];
        [self validateAddressCountryCode:[addressData objectForKey:@"addressCountryCode"]];
        [self validateAddressPostalCode:[addressData objectForKey:@"addressPostalCode"]];
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
        
        NSURL *apiURL = [NSURL URLWithString:LPTS_API_PATH];
        
        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
        
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:jsonData];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
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
    }
}

@end

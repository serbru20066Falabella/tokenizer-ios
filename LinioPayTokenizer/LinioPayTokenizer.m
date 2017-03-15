//
//  LinioPayTokenizer.m
//  pay-tokenizer-ios
//
//  Created by Omar on 3/3/17.
//  Copyright © 2017 omargon. All rights reserved.
//

#import "LinioPayTokenizer.h"

@implementation LinioPayTokenizer {
    NSString *tokenizationKey;
    NSMutableArray *errorMessages;
}

-(id)initWithKey: (NSString *)key
{
    self = [super init];

    errorMessages = [NSMutableArray arrayWithCapacity:1];

    if(self)
    {
        if ([self validateKey: key])
        {
            tokenizationKey = key;
        }
    }
    return self;
}

-(BOOL)validateKey: (NSString *)key
{
    NSString *requiredAlert = @"Tokenization key is required";

    if (key == nil) {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    NSMutableString *formattedKey = [NSMutableString stringWithString:key];
    formattedKey = [self trimString:formattedKey];

    if ([formattedKey length] == 0)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    return true;
}

-(BOOL)validateName: (NSString *)name
{
    NSUInteger minCharacters = 5;
    NSUInteger maxCharacters = 60;
    NSString *requiredAlert = @"Card holder name is required";
    NSString *invalidAlert = @"Invalid card holder name";
    NSString *maxAlert = [NSString
                          stringWithFormat: @"Card holder name should have less than %lu characters", maxCharacters];

    if (name == nil)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    NSMutableString *formattedName = [NSMutableString stringWithString:name];
    formattedName = [self trimString:formattedName];

    if ([formattedName length] == 0)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }
    if ([formattedName length] < minCharacters)
    {
        [errorMessages addObject: invalidAlert];
        return false;
    }
    if ([formattedName length] > maxCharacters) {
        [errorMessages addObject: maxAlert];
        return false;
    }
    return true;
}

-(BOOL)validateNumber: (NSString *)cardNumber
{

    NSString *requiredAlert = @"Credit card number is required";
    NSString *invalidAlert = @"Invalid credit card number";

    if (cardNumber == nil)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }


    // Accept only digits, dashes or spaces


    NSError *error = nil;

    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern: @"\\s+|-"
                                  options:NSRegularExpressionCaseInsensitive error: &error];

    NSMutableString *modifiedCardNumber = [NSMutableString
                                       stringWithString:[regex
                                                         stringByReplacingMatchesInString:cardNumber
                                                         options:0
                                                         range:NSMakeRange(0, [cardNumber length])
                                                         withTemplate:@""]];

    if ([modifiedCardNumber length] == 0)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    // accept only digits after removing dashes or spaces

    if([self testRegExp:modifiedCardNumber withPattern:@"^\\d+$"] == 0) {
        [errorMessages addObject: invalidAlert];
        return false;
    }

    // Luhn Check

    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[modifiedCardNumber length]];

    [cardNumber
     enumerateSubstringsInRange:NSMakeRange(0, [modifiedCardNumber length])
     options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences)
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
        [reversedString appendString:substring];
     }];

    NSUInteger oddSum = 0, evenSum = 0;

    for (NSUInteger i = 0; i < [reversedString length]; i++) {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];

        if (i % 2 == 0) {
            evenSum += digit;
        }
        else {
            oddSum += digit / 5 + (2 * digit) % 10;
        }
    }

    if ((oddSum + evenSum) % 10 != 0) {
        [errorMessages addObject: invalidAlert];
        return false;
    }

    return true;
}

-(BOOL)validateCVC: (NSString *)cvcNumber card:(NSString *)cardNumber
{
    // Field is optional
    if (cvcNumber != nil) {

        NSInteger validCVCNumberLength = 3;
        NSString *invalidAlert = @"Invalid CVC number";

        NSMutableString *formattedCVC = [NSMutableString stringWithString:cvcNumber];
        formattedCVC = [self trimString:formattedCVC];

        NSMutableString *formattedCardNumber = [NSMutableString stringWithString:cardNumber];
        formattedCardNumber = [self trimString:formattedCardNumber];

        // If card Type Amex expect 4 digits CVC number

        if ([self testRegExp:formattedCardNumber withPattern:@"^3[47]"]) {
            validCVCNumberLength = 4;
        }


        if (![self testRegExp:formattedCVC withPattern:[NSString stringWithFormat:@"^\\d{%lu}$", validCVCNumberLength]]) {
            [errorMessages addObject: invalidAlert];
            return false;
        }
    }
    return true;
}

-(BOOL)validateExpDate: (NSString *)monthValue year:(NSString *)yearValue
{
    BOOL missingData = false;

    NSString *requiredMonthAlert = @"Expiration month is required";
    NSString *requiredYearAlert = @"Expiration year is required";
    NSString *invalidAlert = @"Invalid expiration date";

    if (monthValue == nil)
    {
        [errorMessages addObject: requiredMonthAlert];
        missingData = true;
    }

    if (yearValue == nil)
    {
        [errorMessages addObject: requiredYearAlert];
        missingData = true;
    }

    if (missingData) {
        return false;
    }

    NSMutableString *formattedMonth = [NSMutableString stringWithString:monthValue];
    formattedMonth = [self trimString:formattedMonth];

    NSMutableString *formattedYear = [NSMutableString stringWithString:yearValue];
    formattedYear = [self trimString:formattedYear];

    if ([formattedMonth length] == 0)
    {
        [errorMessages addObject: requiredMonthAlert];
        missingData = true;
    }

    if ([formattedYear length] == 0)
    {
        [errorMessages addObject: requiredYearAlert];
        missingData = true;
    }

    if (missingData) {
        return false;
    }

    if (![self testRegExp:formattedMonth withPattern:@"^\\d{1,2}$"] ||
        ![self testRegExp:formattedYear withPattern:@"^\\d{4}$"])
    {
        [errorMessages addObject: invalidAlert];
        return false;
    }

    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];

    NSDate *expirationDate =[dateFormatter dateFromString:[NSString
                                                           stringWithFormat:@"%@-%@",
                                                           formattedYear,
                                                           formattedMonth ]];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    expirationDate = [calendar dateByAddingComponents:dateComponents toDate:expirationDate options:0];

    if ([expirationDate compare:today] == NSOrderedAscending) {
        [errorMessages addObject: invalidAlert];
        return false;
    }

    return true;
}

-(BOOL)validateAddressStreet1: (NSString *)addressStreet1
{
    NSUInteger maxCharacters = 255;
    NSString *requiredAlert = @"Address street 1 is required";
    NSString *maxAlert = [NSString stringWithFormat:
                          @"Address street 1 value should have less than %lu characters", maxCharacters];

    if (addressStreet1 == nil)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    NSMutableString *formattedAddressStreet1 = [NSMutableString stringWithString:addressStreet1];
    formattedAddressStreet1 = [self trimString:formattedAddressStreet1];

    if ([formattedAddressStreet1 length] == 0)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    if ([formattedAddressStreet1 length] > maxCharacters) {
        [errorMessages addObject: maxAlert];
        return false;
    }
    return true;
}

-(BOOL)validateAddressStreet2: (NSString *)addressStreet2
{
    // Field is optional
    if (addressStreet2 != nil)
    {
        NSUInteger maxCharacters = 255;
        NSString *maxAlert = [NSString stringWithFormat:
                              @"Address street 2 value should have less than %lu characters", maxCharacters];

        NSMutableString *formattedAddressStreet2 = [NSMutableString stringWithString:addressStreet2];
        formattedAddressStreet2 = [self trimString:formattedAddressStreet2];

        if ([formattedAddressStreet2 length] > maxCharacters) {
            [errorMessages addObject: maxAlert];
            return false;
        }
    }
    return true;
}

-(BOOL)validateAddressCity: (NSString *)city
{
    NSUInteger maxCharacters = 255;
    NSString *requiredAlert = @"City value is required";
    NSString *maxAlert = [NSString stringWithFormat:
                          @"City value should have less than %lu characters", maxCharacters];

    if (city == nil)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    NSMutableString *formattedCity = [NSMutableString stringWithString:city];
    formattedCity = [self trimString:formattedCity];

    if ([formattedCity length] == 0)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    if ([formattedCity length] > maxCharacters) {
        [errorMessages addObject: maxAlert];
        return false;
    }
    return true;
}

-(BOOL)validateAddressState: (NSString *)state
{
    NSUInteger maxCharacters = 120;
    NSString *requiredAlert = @"State value is required";
    NSString *maxAlert = [NSString stringWithFormat:
                          @"State value should have less than %lu characters", maxCharacters];

    if (state == nil)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    NSMutableString *formattedState = [NSMutableString stringWithString:state];
    formattedState = [self trimString:formattedState];

    if ([formattedState length] == 0)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    if ([formattedState length] > maxCharacters) {
        [errorMessages addObject: maxAlert];
        return false;
    }
    return true;
}

-(BOOL)validateAddressCountryCode: (NSString *)countryCode
{
    NSUInteger numberOfCharacters = 3;
    NSString *requiredAlert = @"Country code value is required";
    NSString *invalidAlert = [NSString stringWithFormat:
                          @"Country code value should contain %lu alpha characters", numberOfCharacters];

    if (countryCode == nil)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    NSMutableString *formattedCountryCode = [NSMutableString stringWithString:countryCode];
    formattedCountryCode = [self trimString:formattedCountryCode];

    if ([formattedCountryCode length] == 0)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    if ([self
         testRegExp:formattedCountryCode
         withPattern:[NSString stringWithFormat:@"^[A-Za-z]{%lu}$", numberOfCharacters]] == 0)
    {
        [errorMessages addObject: invalidAlert];
        return false;
    }
    return true;
}

-(BOOL)validateAddressPostalCode: (NSString *)postalCode
{
    NSUInteger maxCharacters = 20;
    NSString *requiredAlert = @"Postal code is required";
    NSString *maxAlert = [NSString stringWithFormat:
                          @"Postal code value should have less than %lu characters", maxCharacters];

    if (postalCode == nil)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    NSMutableString *formattedPostalCode = [NSMutableString stringWithString:postalCode];
    formattedPostalCode = [self trimString:formattedPostalCode];

    if ([formattedPostalCode length] == 0)
    {
        [errorMessages addObject: requiredAlert];
        return false;
    }

    if ([formattedPostalCode length] > maxCharacters) {
        [errorMessages addObject: maxAlert];
        return false;
    }
    return true;

}

-(NSMutableString *)trimString: (NSMutableString *)string
{
    NSError *error = nil;

    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern: @"^\\s+|\\s+$"
                                  options:NSRegularExpressionCaseInsensitive error: &error];

    NSRegularExpression *regex2 = [NSRegularExpression
                                  regularExpressionWithPattern: @"\\s+"
                                  options:NSRegularExpressionCaseInsensitive error: &error];

    NSMutableString *modifiedString = [NSMutableString
                                           stringWithString:[regex
                                                             stringByReplacingMatchesInString:string
                                                             options:0
                                                             range:NSMakeRange(0, [string length])
                                                             withTemplate:@""]];
    modifiedString = [NSMutableString
                      stringWithString:[regex2
                                        stringByReplacingMatchesInString:modifiedString
                                        options:0
                                        range:NSMakeRange(0, [modifiedString length])
                                        withTemplate:@" "]];
    return modifiedString;
}

-(NSUInteger)testRegExp: (NSString *)string withPattern:(NSString *) pattern
{
    NSError *error = nil;

    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern: pattern
                                  options:NSRegularExpressionCaseInsensitive error: &error];

    return [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
}

-(void)requestToken: (NSDictionary *)formValues completion: (void (^) (NSDictionary *, NSError *)) completion
{
    NSLog(@"%@", formValues);

    errorMessages = [NSMutableArray arrayWithCapacity:1];

    [self validateKey: tokenizationKey];
    [self validateName: [formValues objectForKey:@"name"]];
    [self validateNumber: [formValues objectForKey:@"number"]];
    [self validateCVC: [formValues objectForKey:@"cvc"]  card: [formValues objectForKey:@"number"]];
    [self validateExpDate: [formValues objectForKey:@"month"] year: [formValues objectForKey:@"year"]];
    if ([formValues objectForKey:@"address"] != nil)
    {
        NSDictionary *addressData = [formValues objectForKey:@"address"];
        [self validateAddressStreet1: [addressData objectForKey:@"addressStreet1"]];
        [self validateAddressStreet2: [addressData objectForKey:@"addressStreet2"]];
        [self validateAddressCity: [addressData objectForKey:@"addressCity"]];
        [self validateAddressState: [addressData objectForKey:@"addressState"]];
        [self validateAddressCountryCode: [addressData objectForKey:@"addressCountryCode"]];
        [self validateAddressPostalCode: [addressData objectForKey:@"addressPostalCode"]];
    }

    if ([errorMessages count] > 0) {



        id objectInstance;
        NSUInteger indexKey = 0U;

        NSMutableDictionary *errorsDictionary = [[NSMutableDictionary alloc] init];
        for (objectInstance in errorMessages)
            [errorsDictionary setObject:objectInstance forKey:[NSString stringWithFormat:@"Error-%lu", indexKey++]];

        completion(nil,[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:errorsDictionary]);

    } else {

        NSDictionary *postData =@{
            @"tokenization_key": tokenizationKey,
            @"token": @{
                @"one_time": @"false",
                @"payment_method": @{
                    @"charge_card": formValues,
                },
            },
        };

        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData
                                                           options:(NSJSONWritingOptions) 0
                                                             error:&error];

        if (!jsonData)
        {
            NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
            completion(nil,[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{@"Error message": @"JSON error"}]);
        }

        // Submit form
        NSString* apiPath = @"https://echo.getpostman.com/post";

        NSURL *apiURL = [NSURL URLWithString: apiPath];

        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [urlRequest setHTTPMethod:@"POST"];

        [urlRequest setHTTPBody: jsonData];

        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if(error!=nil){
                completion(nil,error);
            }else{
                NSError* jsonError;
                NSDictionary* results = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:&jsonError];
                if(jsonError!=nil){
                    completion(nil,jsonError);
                }else{
                    completion(results,nil);
                }
            }
        }];
    }
}

@end

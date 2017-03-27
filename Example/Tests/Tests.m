//
//  LinioPayTokenizerTests.m
//  LinioPayTokenizerTests
//
//  Created by omargon on 03/14/2017.
//  Copyright (c) 2017 omargon. All rights reserved.
//
#import "LinioPayTokenizer.h"

@import XCTest;

@interface Tests : XCTestCase

@property (strong, nonatomic) LinioPayTokenizer *tokenizer;
@property (strong, nonatomic) NSString *stringWithMoreThan255Characters;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.tokenizer = [[LinioPayTokenizer alloc] initWithKey:@"test_0618f5c21603cd9d33ba8a8f0c9e2446283"];
    
    self.stringWithMoreThan255Characters = @"Omar Gonzalez Gonzalez Family Friends Pets and Community of Doral FloridaOmar Gonzalez Gonzalez Family Friends Pets and Community of Doral FloridaOmar Gonzalez Gonzalez Family Friends Pets and Community of Doral FloridaOmar Gonzalez Gonzalez Family Friends Pets and Community of Doral FloridaOmar Gonzalez Gonzalez Family Friends Pets and Community of Doral FloridaOmar Gonzalez Gonzalez Family Friends Pets and Community of Doral FloridaOmar Gonzalez Gonzalez Family Friends Pets and Community of Doral Florida";
}

- (void)tearDown
{
    self.tokenizer = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithKey
{
    XCTAssertNotNil(self.tokenizer, @"Object instantiated");
}

- (void)testValidateKeyWithValidKey
{
    [self.tokenizer validateKey:@"test_0618f5c21603cd9d33ba8a8f0c9e2446283" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateKey with valid data should return a nil error object");
         XCTAssertTrue(data, @"True if valid key value");
     }];
}

- (void)testValidateKeyWithNil
{
    [self.tokenizer validateKey:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateKey with invalid data should return an error object");
         XCTAssertFalse(data, @"False if invalid key value");
     }];
}

- (void)testValidateKeyWithStringLengthEqual0
{
    [self.tokenizer validateKey:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateKey when key length is 0 should return an error object");
         XCTAssertFalse(data, @"False when key length is 0");
     }];
}

- (void)testValidateKeyWithStringLengthLessThan40
{
    [self.tokenizer validateKey:@"0618f5c21603cd9d33ba8a8f0c9e2446283" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateKey when key length is less than 40 characters should return an error object");
         XCTAssertFalse(data, @"False when key length is less than 40 characters");
     }];
}

- (void)testValidateKeyWithStringLengthMoreThan40
{
    [self.tokenizer validateKey:@"wefkssladfs0618f5c21603cd9d33ba8a8f0c9e2446283" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateKey when key length is less more than 40 characters should return an error object");
         XCTAssertFalse(data, @"False when key length is less more than 40 characters");
     }];
}

- (void)testValidateNameWithValidValue
{
    [self.tokenizer validateName:@"Omar Gonzalez" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateName with valid data should return a nil error object");
         XCTAssertTrue(data, @"True if valid cardholder name value");
     }];
}

- (void)testValidateNameWithNil
{
    [self.tokenizer validateName:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateName with invalid data returns error object");
         XCTAssertFalse(data, @"False when key has a nil value");
     }];
}

- (void)testValidateNameWithStringLengthEqual0
{
    [self.tokenizer validateName:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateName when key string is empty returns an error object");
         XCTAssertFalse(data, @"False when key string is empty");
     }];
}

- (void)testValidateNameWithStringLengthLessThan5
{
    [self.tokenizer validateName:@"Omar" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateName when name length is less than 60 charaters returns error object");
         XCTAssertFalse(data, @"False when name length is less than 60 charaters");
     }];
}

- (void)testValidateNameWithStringLengthMoreThan60
{
    [self.tokenizer validateName:@"Omar Gonzalez Gonzalez Family Friends Pets and Community of Doral Florida"
                      completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateName with invalid data returns error object");
         XCTAssertFalse(data, @"False when name length is more than 60 charaters");
     }];
}

- (void)testValidateCardNumberWithValidValues
{
    NSArray *cardNumbers = @[
                             @"378282246310005",
                             @"371449635398431",
                             @"378734493671000",
                             @"5610591081018250",
                             @"30569309025904",
                             @"38520000023237",
                             @"6011111111111117",
                             @"6011000990139424",
                             @"3530111333300000",
                             @"3566002020360505",
                             @"5555555555554444",
                             @"5105105105105100",
                             @"4111111111111111",
                             @"4012888888881881",
                             @"4222222222222",
                             @"5019717010103742",
                             @"6331101999990016"];
    
    for (NSString *number in cardNumbers)
    {
        [self.tokenizer validateNumber:number completion:^(BOOL data, NSError *error)
         {
             XCTAssertNil(error, @"validateCardNumber with valid data should return a nil error object");
             XCTAssertTrue(data, @"True if valid cardNumber value");
         }];
    }
}

- (void)testValidateCardNumberWithNil
{
    [self.tokenizer validateNumber:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateCardNumber with invalid data returns error object");
         XCTAssertFalse(data, @"False when number has a nil value");
     }];
}

- (void)testValidateCardNumberWithStringLengthEqual0
{
    [self.tokenizer validateNumber:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateNumber when number string is empty returns an error object");
         XCTAssertFalse(data, @"False when number string is empty");
     }];
}

- (void)testValidateCardNumberWithAlphaCharacters
{
    [self.tokenizer validateNumber:@"wefwefwefr2323wfwfwe" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateNumber when number value includes alpha characters returns an error object");
         XCTAssertFalse(data, @"False when number value includes alpha characters");
     }];
}

- (void)testValidateCardNumberWithInvalidNumber
{
    [self.tokenizer validateNumber:@"0003492383232356" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateNumber when number value doesn't pass the luhn check returns an error object");
         XCTAssertFalse(data, @"False when number value doesn't pass the luhn check");
     }];
}

- (void)testValidateCVCWithValidValues
{
    [self.tokenizer validateCVC:@"123" card:@"4111111111111111" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateCVC with valid data should return a nil error object");
         XCTAssertTrue(data, @"True if valid cvc card number combination");
     }];
    
    [self.tokenizer validateCVC:@"1234" card:@"378282246310005" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateCVC with valid data should return a nil error object");
         XCTAssertTrue(data, @"True if valid cvc card number AMEX combination");
     }];
}

- (void)testValidateCVCWithInValidValues
{
    [self.tokenizer validateCVC:@"1234" card:@"4111111111111111" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateCVC with invalid CVC and credit card number conbination");
         XCTAssertFalse(data, @"False with invalid CVC and credit card number conbination");
     }];
    
    [self.tokenizer validateCVC:@"123" card:@"378282246310005" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateCVC with invalid CVC and AMEX credit card number conbination");
         XCTAssertFalse(data, @"False with invalid CVC and AMEX credit card number conbination");
     }];
}


- (void)testValidateExpDateWithFutureDate
{
    [self.tokenizer validateExpDate:@"02" year:@"3001" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateExpDate with valid data should return a nil error object");
         XCTAssertTrue(data, @"True if valid expiration date");
     }];
}

- (void)testValidateExpDateWithPastDate
{
    [self.tokenizer validateExpDate:@"12" year:@"2016" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate with invalid expiration date set in the past returns an error object");
         XCTAssertFalse(data, @"False with invalid expiration date set in the past");
     }];
}

- (void)testValidateExpDateWithMissingData
{
    [self.tokenizer validateExpDate:nil year:@"3001" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate when month is nil returns an error object");
         XCTAssertFalse(data, @"False when month is nil");
     }];
    
    [self.tokenizer validateExpDate:@"02" year:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate when year is nil returns an error object");
         XCTAssertFalse(data, @"False when year is nil");
     }];
    
    [self.tokenizer validateExpDate:@"" year:@"3001" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate when month string is empty returns an error object");
         XCTAssertFalse(data, @"False when month string is empty");
     }];
    
    [self.tokenizer validateExpDate:@"02" year:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate when year string is empty returns an error object");
         XCTAssertFalse(data, @"False when year string is empty");
     }];
}

- (void)testValidateExpDateWithInvalidData
{
    [self.tokenizer validateExpDate:@"1234" year:@"3001" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate when month has more than 2 digits returns an error object");
         XCTAssertFalse(data, @"False when month has more than 2 digits");
     }];
    
    [self.tokenizer validateExpDate:@"02" year:@"02" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate when year has less than 4 digits returns an error object");
         XCTAssertFalse(data, @"False when year has less than 4 digits");
     }];
    
    [self.tokenizer validateExpDate:@"as" year:@"3001" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate when month contains alpha characters returns an error object");
         XCTAssertFalse(data, @"False when month contains alpha characters");
     }];
    
    [self.tokenizer validateExpDate:@"02" year:@"23456" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateExpDate when year has more than 4 digits returns an error object");
         XCTAssertFalse(data, @"False when year has more than 4 digits");
     }];
}

- (void)testValidateAddressStreet1WithValidValue
{
    [self.tokenizer validateAddressStreet1:@"Here Calle 2 Ayer" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateAddressStreet1 when a valid address street 1 returns a nil error object");
         XCTAssertTrue(data, @"True when a valid address street 1");
     }];
}

- (void)testValidateAddressStreet1WithNil
{
    [self.tokenizer validateAddressStreet1:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressStreet1 when a nil or no address street 1 value returns an error object");
         XCTAssertFalse(data, @"False when a nil or no address street 1");
     }];
}

- (void)testValidateAddressStreet1WithStringLengthEqual0
{
    [self.tokenizer validateAddressStreet1:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressStreet1 when an empty address street 1 returns an error object");
         XCTAssertFalse(data, @"False when an empty address street 1");
     }];
}

- (void)testValidateAddressStreet1WithStringLengthMoreThan255
{
    [self.tokenizer validateAddressStreet1:self.stringWithMoreThan255Characters completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressStreet1 when a address street 1 string value length > 255 returns an error object");
         XCTAssertFalse(data, @"False when a address street 1 string value length > 255");
     }];
}

- (void)testValidateAddressStreet2WithValidValue
{
    [self.tokenizer validateAddressStreet2:@"Here Calle 2 Ayer" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateAddressStreet2 when a valid address street 2 returns a nil error object");
         XCTAssertTrue(data, @"True when a valid address street 2");
     }];
}

- (void)testValidateAddressStreet2WithStringLengthMoreThan255
{
    [self.tokenizer validateAddressStreet2:self.stringWithMoreThan255Characters completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressStreet1 when a address street 2 string value length > 255 returns an error object");
         XCTAssertFalse(data, @"False when a address street 2 string value length > 255");
     }];
}

- (void)testValidateAddressCityWithValidValue
{
    [self.tokenizer validateAddressCity:@"Miami" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateAddressCity when a valid city returns a nil error object");
         XCTAssertTrue(data, @"True when a valid city");
     }];
}

- (void)testValidateAddressCityWithNil
{
    [self.tokenizer validateAddressCity:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressCity when a nil or no address city returns an error object");
         XCTAssertFalse(data, @"False when a nil or no address city");
     }];
}

- (void)testValidateAddressCityWithStringLengthEqual0
{
    [self.tokenizer validateAddressCity:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressCity when an empty city returns an error object");
         XCTAssertFalse(data, @"False when an empty city");
     }];
}

- (void)testValidateAddressCityWithStringLengthMoreThan255
{
    [self.tokenizer validateAddressCity:self.stringWithMoreThan255Characters completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressCity when a city string value length > 255 returns an error object");
         XCTAssertFalse(data, @"False when a city string value length > 255");
     }];
}

- (void)testValidateAddressStateWithValidValue
{
    [self.tokenizer validateAddressState:@"Florida" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateAddressState when a valid state returns a nil error object");
         XCTAssertTrue(data, @"True when a valid state");
     }];
}

- (void)testValidateAddressStateWithNil
{
    [self.tokenizer validateAddressState:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressState when a nil or no address state returns an error object");
         XCTAssertFalse(data, @"False when a nil or no address state");
     }];
}

- (void)testValidateAddressStateWithStringLengthEqual0
{
    [self.tokenizer validateAddressState:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressState when an empty state returns an error object");
         XCTAssertFalse(data, @"False when an empty state");
     }];
}

- (void)testValidateAddressStateWithStringLengthMoreThan120
{
    [self.tokenizer validateAddressState:self.stringWithMoreThan255Characters completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressState when a state string value length > 120 returns an error object");
         XCTAssertFalse(data, @"False when a state string value length > 120");
     }];
}

- (void)testValidateAddressCountryCodeWithValidValue
{
    [self.tokenizer validateAddressCountryCode:@"USA" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateAddressCountryCode when a valid country code returns a nil error object");
         XCTAssertTrue(data, @"True when a valid country code");
     }];
}

- (void)testValidateAddressCountryCodeWithNil
{
    [self.tokenizer validateAddressCountryCode:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressCountryCode when a nil or no address country code returns an error object");
         XCTAssertFalse(data, @"False when a nil or no address country code");
     }];
}

- (void)testValidateAddressCountryCodeWithStringLengthEqual0
{
    [self.tokenizer validateAddressCountryCode:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressCountryCode when an empty country code returns an error object");
         XCTAssertFalse(data, @"False when an empty country code");
     }];
}

- (void)testValidateAddressCountryCodeWithStringLengthMoreThan3
{
    [self.tokenizer validateAddressCountryCode:@"MXCC" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressCountryCode when a country code string value length > 3 returns an error object");
         XCTAssertFalse(data, @"False when a country code string value length > 3");
     }];
}

- (void)testValidateAddressPostalCodeWithValidValue
{
    [self.tokenizer validateAddressPostalCode:@"12345" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNil(error, @"validateAddressPostalCode when a valid postal code returns a nil error object");
         XCTAssertTrue(data, @"True when a valid postal code");
     }];
}

- (void)testValidateAddressPostalCodeWithNil
{
    [self.tokenizer validateAddressPostalCode:nil completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressPostalCode when a nil or no address postal code returns an error object");
         XCTAssertFalse(data, @"False when a nil or no address postal code");
     }];
}

- (void)testValidateAddressPostalCodeWithStringLengthEqual0
{
    [self.tokenizer validateAddressPostalCode:@"" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressPostalCode when an empty postal code returns an error object");
         XCTAssertFalse(data, @"False when an empty postal code");
     }];
}

- (void)testValidateAddressPostalCodeWithAlphaCharacters
{
    [self.tokenizer validateAddressPostalCode:@"abcde" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressPostalCode when postal code value containing alpha characters returns an error object");
         XCTAssertFalse(data, @"False when postal code value containing alpha characters");
     }];
}

- (void)testValidateAddressPostalCodeWithStringLengthMoreThan3
{
    [self.tokenizer validateAddressPostalCode:@"123456789012345678901" completion:^(BOOL data, NSError *error)
     {
         XCTAssertNotNil(error, @"validateAddressPostalCode when a postal code string value length > 20 returns an error object");
         XCTAssertFalse(data, @"False when a postal code string value length > 20");
     }];
}

- (void)testRequestTokenWithValidData
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [self.tokenizer requestToken:@{
                                   FORM_DICT_KEY_NAME: @"Omar Gonzalez",
                                   FORM_DICT_KEY_NUMBER: @"4111111111111111",
                                   FORM_DICT_KEY_CVC: @"123",
                                   FORM_DICT_KEY_MONTH: @"02",
                                   FORM_DICT_KEY_YEAR: @"3012",
                                   FORM_DICT_KEY_ADDRESS: @{
                                           FORM_DICT_KEY_STREET_1: @"Here",
                                           FORM_DICT_KEY_STREET_2: @"",
                                           FORM_DICT_KEY_CITY: @"Miami",
                                           FORM_DICT_KEY_STATE: @"Florida",
                                           FORM_DICT_KEY_COUNTRY_CODE: @"USA",
                                           FORM_DICT_KEY_POSTAL_CODE: @"33178",
                                   },
                               }
                      completion: ^(NSDictionary *data, NSError *error)
    {
        // TODO: Assert response once server is available
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testRequestTokenWithValidDataButNoAddress
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [self.tokenizer requestToken:@{
                                   FORM_DICT_KEY_NAME: @"Omar Gonzalez",
                                   FORM_DICT_KEY_NUMBER: @"4111111111111111",
                                   FORM_DICT_KEY_CVC: @"123",
                                   FORM_DICT_KEY_MONTH: @"02",
                                   FORM_DICT_KEY_YEAR: @"3012",
                                   }
                      completion: ^(NSDictionary *data, NSError *error)
     {
         // TODO: Assert response once server is available
         [expectation fulfill];
     }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)testRequestTokenWithOneInvalidField
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Query timed out."];
    [self.tokenizer requestToken:@{
                                   FORM_DICT_KEY_NAME: @"Omar Gonzalez",
                                   FORM_DICT_KEY_NUMBER: @"4111111111111111",
                                   FORM_DICT_KEY_CVC: @"123",
                                   FORM_DICT_KEY_MONTH: @"223", // Invalid Expiration Month
                                   FORM_DICT_KEY_YEAR: @"3012",
                                   }
                      completion: ^(NSDictionary *data, NSError *error)
     {
         XCTAssertNotNil(error, @"RequestToken with invalid expiration month should return an error object");
         XCTAssertNil(data, @"RequestToken with invalid expiration month should return a nil data object");
         [expectation fulfill];
     }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error)
    {
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
    }];
}
@end

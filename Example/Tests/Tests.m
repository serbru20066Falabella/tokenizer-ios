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
    XCTAssertTrue([self.tokenizer validateKey:@"test_0618f5c21603cd9d33ba8a8f0c9e2446283"], @"True if valid key value");
}

- (void)testValidateKeyWithNil
{
    XCTAssertFalse([self.tokenizer validateKey:nil], @"False when key is nil");
}

- (void)testValidateKeyWithStringLengthEqual0
{
    XCTAssertFalse([self.tokenizer validateKey:@""], @"False when key length is 0");
}

- (void)testValidateKeyWithStringLengthLessThan40
{
    XCTAssertFalse([self.tokenizer validateKey:@"0618f5c21603cd9d33ba8a8f0c9e2446283"], @"False if invalid character length with less than 40 characters");
}

- (void)testValidateKeyWithStringLengthMoreThan40
{
    XCTAssertFalse([self.tokenizer validateKey:@"wefkssladfs0618f5c21603cd9d33ba8a8f0c9e2446283"], @"False if invalid character length of more than 40 characters");
}

- (void)testValidateNameWithValidValue
{
    XCTAssertTrue([self.tokenizer validateName:@"Omar Gonzalez"], @"Returns true when a valid name is passed");
}

- (void)testValidateNameWithNil
{
    XCTAssertFalse([self.tokenizer validateName:nil], @"Returns false when a nil or no name value is passed");
}

- (void)testValidateNameWithStringLengthEqual0
{
    XCTAssertFalse([self.tokenizer validateName:@""], @"Returns false when an empty name value is passed");
}

- (void)testValidateNameWithStringLengthLessThan5
{
    XCTAssertFalse([self.tokenizer validateName:@"Omar"], @"Returns false when a name string value length < 5 is passed");
}

- (void)testValidateNameWithStringLengthMoreThan60
{
    XCTAssertFalse([self.tokenizer validateName:@"Omar Gonzalez Gonzalez Family Friends Pets and Community of Doral Florida"], @"Returns false when a name string value length > 60 is passed");
}

- (void)testValidateCardNumberWithValidValues
{
    XCTAssertTrue([self.tokenizer validateNumber:@"378282246310005"], @"Return true with valid Amex number");
    XCTAssertTrue([self.tokenizer validateNumber:@"371449635398431"], @"Return true with valid Amex number");
    XCTAssertTrue([self.tokenizer validateNumber:@"378734493671000"], @"Return true with valid Amex Corp number");
    XCTAssertTrue([self.tokenizer validateNumber:@"5610591081018250"], @"Return true with valid Australian BankCard number");
    XCTAssertTrue([self.tokenizer validateNumber:@"30569309025904"], @"Return true with valid Diners Club number");
    XCTAssertTrue([self.tokenizer validateNumber:@"38520000023237"], @"Return true with valid Diners Club number");
    XCTAssertTrue([self.tokenizer validateNumber:@"6011111111111117"], @"Return true with valid Discover number");
    XCTAssertTrue([self.tokenizer validateNumber:@"6011000990139424"], @"Return true with valid Discover number");
    XCTAssertTrue([self.tokenizer validateNumber:@"3530111333300000"], @"Return true with valid JCB number");
    XCTAssertTrue([self.tokenizer validateNumber:@"3566002020360505"], @"Return true with valid JCB number");
    XCTAssertTrue([self.tokenizer validateNumber:@"5555555555554444"], @"Return true with valid MasterCard number");
    XCTAssertTrue([self.tokenizer validateNumber:@"5105105105105100"], @"Return true with valid MasterCard number");
    XCTAssertTrue([self.tokenizer validateNumber:@"4111111111111111"], @"Return true with valid Visa number");
    XCTAssertTrue([self.tokenizer validateNumber:@"4012888888881881"], @"Return true with valid Visa number");
    XCTAssertTrue([self.tokenizer validateNumber:@"4222222222222"], @"Return true with valid Visa number");
    XCTAssertTrue([self.tokenizer validateNumber:@"5019717010103742"], @"Return true with valid Dankort (PBS) number");
    XCTAssertTrue([self.tokenizer validateNumber:@"6331101999990016"], @"Return true with valid Switch/Solo (Paymentech) number");
}

- (void)testValidateCardNumberWithNil
{
    XCTAssertFalse([self.tokenizer validateNumber:nil], @"Returns false when a nil or no number value is passed");
}


- (void)testValidateCardNumberWithStringLengthEqual0
{
    XCTAssertFalse([self.tokenizer validateNumber:@""], @"Returns false when an empty number value is passed");
}

- (void)testValidateCardNumberWithAlphaCharacters
{
    XCTAssertFalse([self.tokenizer validateNumber:@"wefwefwefr2323wfwfwe"], @"Returns false when number value includes alpha characters");
}

- (void)testValidateCardNumberWithInvalidNumber
{
    XCTAssertFalse([self.tokenizer validateNumber:@"0003492383232356"], @"Returns false when number value doesn't pass the luhn check");
}

- (void)testValidateCVCWithValidValues
{
    XCTAssertTrue([self.tokenizer validateCVC:@"123" card:@"4111111111111111"], @"Returns true with valid CVC and credit card number conbination");
    XCTAssertTrue([self.tokenizer validateCVC:@"1234" card:@"378282246310005"], @"Returns true with valid CVC and AMEX credit card number conbination");
}

- (void)testValidateCVCWithInValidValues
{
    XCTAssertFalse([self.tokenizer validateCVC:@"1234" card:@"4111111111111111"], @"Returns false with invalid CVC and credit card number conbination");
    XCTAssertFalse([self.tokenizer validateCVC:@"123" card:@"378282246310005"], @"Returns true with invalid CVC and AMEX credit card number conbination");
}


- (void)testValidateExpDateWithFutureDate
{
    XCTAssertTrue([self.tokenizer validateExpDate:@"02" year:@"3001"], @"Returns true with valid expiration date set in the future");
}

- (void)testValidateExpDateWithPastDate
{
    XCTAssertFalse([self.tokenizer validateExpDate:@"12" year:@"2016"], @"Returns false with invalid expiration date set in the past");
}

- (void)testValidateExpDateWithMissingData
{
    XCTAssertFalse([self.tokenizer validateExpDate:nil year:@"3001"], @"Returns false when month is nil");
    XCTAssertFalse([self.tokenizer validateExpDate:@"02" year:nil], @"Returns false when year is nil");
    
    XCTAssertFalse([self.tokenizer validateExpDate:@"" year:@"3001"], @"Returns false when month string is empty");
    XCTAssertFalse([self.tokenizer validateExpDate:@"02" year:@""], @"Returns false when year string is empty");
}

- (void)testValidateExpDateWithInvalidData
{
    XCTAssertFalse([self.tokenizer validateExpDate:@"1234" year:@"3001"], @"Returns false when month has more than 2 digits");
    XCTAssertFalse([self.tokenizer validateExpDate:@"02" year:@"02"], @"Returns false when year has less than 4 digits");
    
    XCTAssertFalse([self.tokenizer validateExpDate:@"as" year:@"3001"], @"Returns false when month contains alpha characters");
    XCTAssertFalse([self.tokenizer validateExpDate:@"02" year:@"23456"], @"Returns false when year has more than 4 digits");
}

- (void)testValidateAddressStreet1WithValidValue
{
    XCTAssertTrue([self.tokenizer validateAddressStreet1:@"Here Calle 2 Ayer"], @"Returns true when a valid address street 1 is passed");
}

- (void)testValidateAddressStreet1WithNil
{
    XCTAssertFalse([self.tokenizer validateAddressStreet1:nil], @"Returns false when a nil or no address street 1 value is passed");
}

- (void)testValidateAddressStreet1WithStringLengthEqual0
{
    XCTAssertFalse([self.tokenizer validateAddressStreet1:@""], @"Returns false when an empty address street 1 value is passed");
}


- (void)testValidateAddressStreet1WithStringLengthMoreThan255
{
    XCTAssertFalse([self.tokenizer validateAddressStreet1:self.stringWithMoreThan255Characters], @"Returns false when a address street 1 string value length > 255 is passed");
}

- (void)testValidateAddressStreet2WithValidValue
{
    XCTAssertTrue([self.tokenizer validateAddressStreet2:@"Here Calle 2 Ayer"], @"Returns true when a valid address street 2 is passed");
}

- (void)testValidateAddressStreet2WithNil
{
    XCTAssertTrue([self.tokenizer validateAddressStreet2:nil], @"Returns true even when a nil or no address street 2 value is passed");
}

- (void)testValidateAddressStreet2WithStringLengthEqual0
{
    XCTAssertTrue([self.tokenizer validateAddressStreet2:@""], @"Returns true even when an empty address street 2 value is passed");
}

- (void)testValidateAddressStreet2WithStringLengthMoreThan255
{
    XCTAssertFalse([self.tokenizer validateAddressStreet2:self.stringWithMoreThan255Characters], @"Returns false when a address street 2 string value length > 255 is passed");
}

- (void)testValidateAddressCityWithValidValue
{
    XCTAssertTrue([self.tokenizer validateAddressCity:@"Miami"], @"Returns true when a valid city is passed");
}

- (void)testValidateAddressCityWithNil
{
    XCTAssertFalse([self.tokenizer validateAddressCity:nil], @"Returns false when a nil or no city value is passed");
}

- (void)testValidateAddressCityWithStringLengthEqual0
{
    XCTAssertFalse([self.tokenizer validateAddressCity:@""], @"Returns false when an empty city value is passed");
}

- (void)testValidateAddressCityWithStringLengthMoreThan255
{
    XCTAssertFalse([self.tokenizer validateAddressCity:self.stringWithMoreThan255Characters], @"Returns false when a city string value length > 255 is passed");
}

- (void)testValidateAddressStateWithValidValue
{
    XCTAssertTrue([self.tokenizer validateAddressState:@"Florida"], @"Returns true when a valid state is passed");
}

- (void)testValidateAddressStateWithNil
{
    XCTAssertFalse([self.tokenizer validateAddressState:nil], @"Returns false when a nil or no state value is passed");
}

- (void)testValidateAddressStateWithStringLengthEqual0
{
    XCTAssertFalse([self.tokenizer validateAddressState:@""], @"Returns false when an empty state value is passed");
}

- (void)testValidateAddressStateWithStringLengthMoreThan120
{
    XCTAssertFalse([self.tokenizer validateAddressState:self.stringWithMoreThan255Characters], @"Returns false when a state string value length > 120 is passed");
}

- (void)testValidateAddressCountryCodeWithValidValue
{
    XCTAssertTrue([self.tokenizer validateAddressCountryCode:@"USA"], @"Returns true when a valid country code is passed");
}

- (void)testValidateAddressCountryCodeWithNil
{
    XCTAssertFalse([self.tokenizer validateAddressCountryCode:nil], @"Returns false when a nil or no country code value is passed");
}

- (void)testValidateAddressCountryCodeWithStringLengthEqual0
{
    XCTAssertFalse([self.tokenizer validateAddressCountryCode:@""], @"Returns false when an empty country code value is passed");
}

- (void)testValidateAddressCountryCodeWithStringLengthMoreThan3
{
    XCTAssertFalse([self.tokenizer validateAddressCountryCode:@"MXCC"], @"Returns false when a country code string value length > 3 is passed");
}

- (void)testValidateAddressPostalCodeWithValidValue
{
    XCTAssertTrue([self.tokenizer validateAddressPostalCode:@"12345"], @"Returns true when a valid postal code is passed");
}

- (void)testValidateAddressPostalCodeWithNil
{
    XCTAssertFalse([self.tokenizer validateAddressPostalCode:nil], @"Returns false when a nil or no postal code value is passed");
}

- (void)testValidateAddressPostalCodeWithStringLengthEqual0
{
    XCTAssertFalse([self.tokenizer validateAddressPostalCode:@""], @"Returns false when an empty postal code value is passed");
}

- (void)testValidateAddressPostalCodeWithAlphaCharacters
{
    XCTAssertFalse([self.tokenizer validateAddressPostalCode:@"abcde"], @"Returns false whenpostal code value containing alpha characters is passed");
}

- (void)testValidateAddressPostalCodeWithStringLengthMoreThan3
{
    XCTAssertFalse([self.tokenizer validateAddressPostalCode:@"123456789012345678901"], @"Returns false when a postal code string value length > 20 is passed");
}

- (void)testRequestTokenWithValidData
{
    [self.tokenizer requestToken:@{
                                   @"cardholder": @"Omar Gonzalez",
                                   @"number": @"4111111111111111",
                                   @"cvc": @"123",
                                   @"expiration_month": @"02",
                                   @"expiration_year": @"3012",
                                   @"address": @{
                                           @"street1": @"Here",
                                           @"street2": @"",
                                           @"city": @"Miami",
                                           @"state": @"Florida",
                                           @"country_code": @"USA",
                                           @"postal_code": @"33178",
                                   },
                               }
                      completion: ^(NSDictionary *data, NSError *error)
    {
        XCTAssertNil(error, @"RequestToken with valid data should return a nil error object");
        XCTAssertNotNil(data, @"RequestToken with valid data should return a not nil data object");
    }];
}

- (void)testRequestTokenWithValidDataButNoAddress
{
    [self.tokenizer requestToken:@{
                                   @"cardholder": @"Omar Gonzalez",
                                   @"number": @"4111111111111111",
                                   @"cvc": @"123",
                                   @"expiration_month": @"02",
                                   @"expiration_year": @"3012",
                                   }
                      completion: ^(NSDictionary *data, NSError *error)
     {
         XCTAssertNil(error, @"RequestToken with valid data but no address should return a nil error object");
         XCTAssertNotNil(data, @"RequestToken with valid data but no address should return a not nil data object");
     }];
}

- (void)testRequestTokenWithOneInvalidField
{
    [self.tokenizer requestToken:@{
                                   @"cardholder": @"Omar Gonzalez",
                                   @"number": @"4111111111111111",
                                   @"cvc": @"123",
                                   @"expiration_month": @"223", // Invalid field
                                   @"expiration_year": @"3012",
                                   }
                      completion: ^(NSDictionary *data, NSError *error)
     {
         XCTAssertNotNil(error, @"RequestToken with invalid expiration month should return an error object");
         XCTAssertNil(data, @"RequestToken with invalid expiration month should return a nil data object");
     }];
}
@end

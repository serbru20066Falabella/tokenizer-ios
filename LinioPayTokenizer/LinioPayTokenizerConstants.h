//
//  LinioPayTokenizerConstants.h
//  Pods
//
//  Created by Omar on 3/16/17.
//
//

#import <Foundation/Foundation.h>

#define LPTS_API_PATH   @"https://vault.liniopay.com/token"
#define ERROR_DOMAIN    @"com.LinioPay.Tokenizer.ErrorDomain"

#define FORM_DICT_KEY_NAME          @"name"
#define FORM_DICT_KEY_NUMBER        @"number"
#define FORM_DICT_KEY_CVC           @"cvc"
#define FORM_DICT_KEY_MONTH         @"month"
#define FORM_DICT_KEY_YEAR          @"year"
#define FORM_DICT_KEY_ADDRESS       @"address"
#define FORM_DICT_KEY_STREET_1      @"addressStreet1"
#define FORM_DICT_KEY_STREET_2      @"addressStreet2"
#define FORM_DICT_KEY_CITY          @"addressCity"
#define FORM_DICT_KEY_STATE         @"addressState"
#define FORM_DICT_KEY_COUNTRY_CODE  @"addressCountryCode"
#define FORM_DICT_KEY_POSTAL_CODE   @"addressPostalCode"


#define CHAR_LENGTH_KEY             40
#define CHAR_LENGTH_CVC             3
#define CHAR_LENGTH_CVC_AMEX        4
#define CHAR_LENGTH_COUNTRY_CODE    3

#define MIN_CHAR_NAME               5

#define MAX_CHAR_NAME               60
#define MAX_CHAR_STREET_1           255
#define MAX_CHAR_STREET_2           255
#define MAX_CHAR_CITY               255
#define MAX_CHAR_STATE              120
#define MAX_CHAR_POSTAL_CODE        20

#define ERROR_CODE_REQUIRED_KEY                 100
#define ERROR_CODE_REQUIRED_NAME                105
#define ERROR_CODE_REQUIRED_CARD_NUMBER         110
#define ERROR_CODE_REQUIRED_MONTH               130
#define ERROR_CODE_REQUIRED_YEAR                140
#define ERROR_CODE_REQUIRED_STREET_1            160
#define ERROR_CODE_REQUIRED_CITY                170
#define ERROR_CODE_REQUIRED_STATE               180
#define ERROR_CODE_REQUIRED_COUNTRY_CODE        190
#define ERROR_CODE_REQUIRED_POSTAL_CODE         195

#define ERROR_CODE_INVALID_KEY                  400
#define ERROR_CODE_INVALID_CARD_NUMBER          410
#define ERROR_CODE_INVALID_CVC                  420
#define ERROR_CODE_INVALID_MONTH                430
#define ERROR_CODE_INVALID_YEAR                 440
#define ERROR_CODE_INVALID_EXPIRATION           450
#define ERROR_CODE_INVALID_COUNTRY_CODE         490

#define ERROR_CODE_CHAR_MAX_LIMIT_NAME          505
#define ERROR_CODE_CHAR_MAX_LIMIT_STREET_1      560
#define ERROR_CODE_CHAR_MAX_LIMIT_STREET_2      565
#define ERROR_CODE_CHAR_MAX_LIMIT_CITY          570
#define ERROR_CODE_CHAR_MAX_LIMIT_STATE         580
#define ERROR_CODE_CHAR_MAX_LIMIT_POSTAL_CODE   585

#define ERROR_CODE_CHAR_MIN_LIMIT_NAME          605

#define ERROR_DESC_REQUIRED_KEY                 @"Tokenization Key is Required"
#define ERROR_DESC_REQUIRED_NAME                @"Card Holder Name is Required"
#define ERROR_DESC_REQUIRED_CARD_NUMBER         @"Credit Card Number is Required"
#define ERROR_DESC_REQUIRED_MONTH               @"Expiration Month is Required"
#define ERROR_DESC_REQUIRED_YEAR                @"Expiration Year is Required"
#define ERROR_DESC_REQUIRED_STREET_1            @"Address Street line 1 is Required"
#define ERROR_DESC_REQUIRED_CITY                @"Address City is Required"
#define ERROR_DESC_REQUIRED_STATE               @"Address State is Required"
#define ERROR_DESC_REQUIRED_COUNTRY_CODE        @"Address Country Code is Required"
#define ERROR_DESC_REQUIRED_POSTAL_CODE         @"Address Postal Code is Required"

#define ERROR_DESC_INVALID_KEY                  @"Invalid Tokenization Key - Should Contain 40 Characters"
#define ERROR_DESC_INVALID_CARD_NUMBER          @"Invalid Credit Card Number"
#define ERROR_DESC_INVALID_CVC                  @"Invalid CVC Number"
#define ERROR_DESC_INVALID_MONTH                @"Invalid Expiration Month - Should Contain 2 Numeric Characters"
#define ERROR_DESC_INVALID_YEAR                 @"Invalid Expiration Year - Should Contain 4 Numeric Characters"
#define ERROR_DESC_INVALID_EXPIRATION           @"Invalid Expiration date - Should Containt Current or Future Date"
#define ERROR_DESC_INVALID_COUNTRY_CODE         @"Invalid Country Code - Should Contain 3 Characters Country Code"

#define ERROR_DESC_CHAR_MAX_LIMIT_NAME          @"Card Holder Name Should Have Less Than %lu Characters"
#define ERROR_DESC_CHAR_MAX_LIMIT_STREET_1      @"Address Street line 1 Should Have Less Than %lu Characters"
#define ERROR_DESC_CHAR_MAX_LIMIT_STREET_2      @"Address Street line 2 Should Have Less Than %lu Characters"
#define ERROR_DESC_CHAR_MAX_LIMIT_CITY          @"Address City Should Have Less Than %lu Characters"
#define ERROR_DESC_CHAR_MAX_LIMIT_STATE         @"Address State Should Have Less Than %lu Characters"
#define ERROR_DESC_CHAR_MAX_LIMIT_POSTAL_CODE   @"Address Postal Code Should Have Less Than %lu Characters"

#define ERROR_DESC_CHAR_MIN_LIMIT_NAME          @"Card Holder Name Should Have More Than %lu Characters"

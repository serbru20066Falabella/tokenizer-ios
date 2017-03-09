
/*
NSString* base = @"test";


NSString* qs = [NSString stringWithFormat:@"/url/app?u=@&b=@",key, key2];


NSDate* localDate = [NSDate dateWithTimeIntervalSinceNow:86400];


NSInteger and NSUInteger


NSNumber and NSDecimalNumber


// Formatters

// String to date

// String to number

// Date to whatever


NSNumberFormatter
NSDateFormatter

// BOOL

YES (1)
NO (0)


// Collections


// Read Only
NSArray
NSDictionary

// Mutable
NSMutableArray
NSMutableDictionary

NSArray* arrayOfStrings = @[@"One", @"Two"];
NSDictionary* dictionaryOfStrings = @{@"KeyOne":@"Object1", @"Key2":@"Object2"};


// Fast enumation

for(UITouch* touch in touches){
    // something
}

// Blocks

// Blocks are Objects that represent a single puece of executable code rather than the typical OO objevt with state and behaviour

// Can be passed to other functions

// Simpler way to do implement callback funcutons tan protocols


void (^ablock)() = ^{
    NSLog(@"thisis a block");
};
// calling a block
ablock();
void (^anotherblock)(NSString*) = ^(NSString* param) {
    NSLog(@"Another block %@", param);
};
anotherblock(@"Hello");

*/

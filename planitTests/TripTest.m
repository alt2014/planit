//
//  TripTest.m
//  planit
//
//  Created by Peter Phan on 5/26/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Trip.h"

@interface TripTest : XCTestCase

@end

@implementation TripTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddress
{
    NSString *street = @"111 Test Ave.";
    NSString *city = @"Stanford";
    NSString *state = @"CA";
    NSString *country = @"US";
    NSUInteger postal = 94541;
    Address *addr = [[Address alloc] initWithStreet:street city:city state:state country:country postal:postal];
    
    NSString *str = [addr asString];

    XCTAssertEqualObjects(str, @"111 Test Ave., Stanford, CA, US 94541", @"Should have matched");
}

- (void)testTrip {
    // January 1, 2011 to January 10, 2011
    NSInteger month = 1;
    NSInteger year = 2011;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [[NSDateComponents alloc] init];
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    
    [components1 setDay:1];
    [components1 setMonth:month];
    [components1 setYear:year];
    
    [components2 setDay:10];
    [components2 setMonth:month];
    [components2 setYear:year];
    
    NSDate *start = [calendar dateFromComponents:components1];
    NSDate *end = [calendar dateFromComponents:components2];
    
    Trip *t = [[Trip alloc] initWithName:@"Moscow" start:start end:end];
    NSArray *days = [t getDays];
    
    XCTAssertEqualObjects(@"Moscow", t.name, @"Trip should be named Moscow");
    XCTAssertEqual(10, days.count, @"Should be 10");
    
    //Create the dateformatter object
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    
    //Set the required date format
    [formatter setDateFormat:@"M-d-yyyy"];
    
    // Test if each Day has the correct NSDate values
    for (int i = 0; i < days.count; i++) {
        Day *d = [days objectAtIndex:i];
        NSDate* date = d.date;
        
        //Get the string date
        NSString *str = [formatter stringFromDate:date];
        
        NSInteger day = 1 + i;
        NSString *comp = [NSString stringWithFormat:@"%d-%d-%d", month, day, year];
        XCTAssertEqualObjects(str, comp, @"Days should be equal");
    }
    
    // Test getting a Day from a Trip by supplying a valid date within the Trip Interval
    NSDateComponents *validDate = [[NSDateComponents alloc] init];
    [validDate setDay:4];
    [validDate setMonth:month];
    [validDate setYear:year];
    NSDate *vDate = [calendar dateFromComponents:validDate];
    Day *vDay = [t getDayForDate:vDate];
    XCTAssertNotEqualObjects(vDay, nil, @"SHOULD NOT BE NULL!");
    XCTAssertEqualObjects(@"1-4-2011", [formatter stringFromDate:vDay.date], @"Date should be equal");
    
    [validDate setDay:11];
    // Test to see if Day is NIL from an invalid Date NOT in the trip interval
    NSDate *ivDate = [calendar dateFromComponents:validDate];
    XCTAssertEqualObjects(nil, [t getDayForDate:ivDate], @"SHOULD BE NIL");
}

@end

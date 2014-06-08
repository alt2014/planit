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

- (void)testTripMoveStart {
    //Create the dateformatter object
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    
    //Set the required date format
    [formatter setDateFormat:@"M-d-yyyy"];
    
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
    NSDate *newStart = [calendar dateFromComponents:components2];
    
    Day *d = [[t getDays] firstObject];
    
    XCTAssertEqualObjects(@"1-1-2011", [formatter stringFromDate:d.date], @"equal to 1-1-2011");
    XCTAssertEqualObjects(@"1-10-2011", [formatter stringFromDate:newStart], @"equal to 1-10-2011");
    [t moveStartDateTo:newStart];
    d = [[t getDays] firstObject];
    int daysBetween = [Trip daysBetween:start and:start];
    XCTAssertEqual(0, daysBetween, @"Days between test");
    XCTAssertEqualObjects(@"1-10-2011", [formatter stringFromDate:d.date], @"equal to 1-10-2011");
    
    NSArray *days = [t getDays];
    XCTAssertEqual(10, days.count, @"Should be 10");
    
    // Test if each Day has the correct NSDate values
    for (int i = 0; i < days.count; i++) {
        Day *d = [days objectAtIndex:i];
        NSDate* date = d.date;
        
        //Get the string date
        NSString *str = [formatter stringFromDate:date];
        
        NSInteger day = 10 + i;
        NSString *comp = [NSString stringWithFormat:@"%d-%d-%d", month, day, year];
        XCTAssertEqualObjects(str, comp, @"Days should be equal");
    }
}

- (void)testTripChangeStart {
    //Create the dateformatter object
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    
    //Set the required date format
    [formatter setDateFormat:@"M-d-yyyy"];
    
    // January 1, 2011 to January 10, 2011
    NSInteger month = 1;
    NSInteger year = 2011;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [[NSDateComponents alloc] init];
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    
    [components1 setDay:5];
    [components1 setMonth:month];
    [components1 setYear:year];
    
    [components2 setDay:14];
    [components2 setMonth:month];
    [components2 setYear:year];
    
    NSDate *start = [calendar dateFromComponents:components1];
    NSDate *end = [calendar dateFromComponents:components2];
    NSDate *nextToLast = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:end];
    
    XCTAssertEqualObjects(@"1-13-2011", [formatter stringFromDate:nextToLast], @"simple test");
    XCTAssertEqual([Trip daysBetween:start and:nextToLast], 8, @"simple daysbetween test");
    
    Trip *t = [[Trip alloc] initWithName:@"Moscow" start: start end: end];
    
    NSDate *threeDaysEarlier = [NSDate dateWithTimeInterval:60*60*24*-3 sinceDate:start];
    // Move trip 3 days earlier
    BOOL result = [t changeStartDateTo:threeDaysEarlier];
    XCTAssertEqual(YES, result, @"SHOULD BE YES");
    XCTAssertEqual(13, [[t getDays] count], @"number of days...");

    NSDate *firstDate = [t start];
    NSDate *lastDate = [t end];
    XCTAssertEqualObjects(@"1-2-2011", [formatter stringFromDate:firstDate], @"1-2-2011");
    XCTAssertEqualObjects(@"1-14-2011", [formatter stringFromDate:lastDate], @"1-14-2011");
    
    // Move start date back to January 5, 2011
    [t changeStartDateTo:start];
    XCTAssertEqual(10, [t lengthOfTrip], @"restart");
    firstDate = ((Day*)[[t getDays] firstObject]).date;
    lastDate = t.end;
    XCTAssertEqualObjects(@"1-5-2011", [formatter stringFromDate:firstDate], @"1-2-2011");
    XCTAssertEqualObjects(@"1-14-2011", [formatter stringFromDate:lastDate], @"1-14-2011");
    
    result = [t changeStartDateTo: end];
    XCTAssertEqual(YES, result, @"SHOULD BE YES!");
    XCTAssertEqual(1, [t lengthOfTrip], @"just dis last day!");

    result = [t changeStartDateTo:nextToLast];
    XCTAssertEqual(YES, result, @"SHOULD BE YES!");
    XCTAssertEqual(2, [t lengthOfTrip], @"just dis last day!");
    
    result = [t changeStartDateTo:[NSDate dateWithTimeInterval:60*60*24*1 sinceDate: end]];
    XCTAssertEqual(NO, result, @"SHOULD BE NO");
}

- (void)testTripChangeEnd {
    //Create the dateformatter object
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    
    //Set the required date format
    [formatter setDateFormat:@"M-d-yyyy"];
    
    // January 1, 2011 to January 10, 2011
    NSInteger month = 1;
    NSInteger year = 2011;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [[NSDateComponents alloc] init];
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    
    [components1 setDay:5];
    [components1 setMonth:month];
    [components1 setYear:year];
    
    [components2 setDay:14];
    [components2 setMonth:month];
    [components2 setYear:year];

    NSDate *start = [calendar dateFromComponents:components1];
    NSDate *end = [calendar dateFromComponents:components2];
    Trip *t = [[Trip alloc] initWithName:@"Moscow" start: start end: end];
    BOOL result = [t changeEndDateTo:end];
    XCTAssertEqual(NO, result, @"NO");
    
    
    NSDate *dayAfterEnd = [NSDate dateWithTimeInterval:60*60*24 sinceDate:end];
    NSDate *dayBeforeStart = [NSDate dateWithTimeInterval:60*60*-24 sinceDate:start];
    // change end date to January 15, 2011
    result = [t changeEndDateTo:dayAfterEnd];
    XCTAssertEqual(YES, result, @"valid");
    XCTAssertEqual(11, [t lengthOfTrip], @"11");
    NSDate *first = t.start;
    NSDate *last = t.end;
    XCTAssertEqualObjects(@"1-5-2011", [formatter stringFromDate:first], @"");
    XCTAssertEqualObjects(@"1-15-2011", [formatter stringFromDate:last], @"");
    
    result = [t changeEndDateTo:dayBeforeStart];
    XCTAssertEqual(NO, result, @"invalid");
    
    NSDate *threeDaysEarlier = [NSDate dateWithTimeInterval:60*60*24*-3 sinceDate:last];
    // Trip should be from Jan 5 to Jan 12
    result = [t changeEndDateTo:threeDaysEarlier];
    XCTAssertEqual(YES, result, @"");
    XCTAssertEqual(8, [t lengthOfTrip], @"");
    
    first = t.start;
    last = t.end;
    XCTAssertEqualObjects(@"1-5-2011", [formatter stringFromDate:first], @"");
    XCTAssertEqualObjects(@"1-12-2011", [formatter stringFromDate:last], @"");
    
    // Trip is one day on Jan 5, 2011
    result = [t changeEndDateTo:start];
    XCTAssertEqual(YES, result, @"");
    first = t.start;
    last = t.end;
    XCTAssertEqualObjects(@"1-5-2011", [formatter stringFromDate:first], @"");
    XCTAssertEqualObjects(@"1-5-2011", [formatter stringFromDate:last], @"");
    XCTAssertEqual(1, [t lengthOfTrip], @"");

}

@end

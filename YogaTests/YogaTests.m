#import "YogaTests.h"

static NSString * const kPathToClassesXML = @"/Users/zackchandler/dev/Yoga/YogaTests/query_classes_result.xml";

@interface YogaTests()

- (NSData *)classesXMLData;

@end

@implementation YogaTests

- (void)testParsingClassesXML {
    MindBodyParser *parser = [[MindBodyParser alloc] init];

    NSArray *klasses = [parser parseClassesXML:[self classesXMLData]];

    [parser release];

    // Check that number of classes matches
    STAssertTrue(18 == [klasses count], @"Classes count incorrect.");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    // Check class #1 - AM class
    NSDictionary *class1 = (NSDictionary *)[klasses objectAtIndex:0];
    
    STAssertEqualObjects(@"Yoga Blend (1/2) &amp;#9835;", [class1 objectForKey:kClassName], @"Class name incorrect");
    STAssertEqualObjects(@"Sonia Roberts", [class1 objectForKey:kInstructorName], @"Instructor name incorrect");
    
    NSDate *startDate = (NSDate *)[class1 objectForKey:kStartDate];
    STAssertEqualObjects(@"8/17/11 6:00 AM", [dateFormatter stringFromDate:startDate], @"Start date incorrect");

    NSDate *endDate = (NSDate *)[class1 objectForKey:kEndDate];
    STAssertEqualObjects(@"8/17/11 7:00 AM", [dateFormatter stringFromDate:endDate], @"End date incorrect");
    
    // Check class #17 - PM class
    NSDictionary *class17 = (NSDictionary *)[klasses objectAtIndex:16];
    
    STAssertEqualObjects(@"Vinyasa Flow (2) &amp;#9835;", [class17 objectForKey:kClassName], @"Class name incorrect");
    STAssertEqualObjects(@"Otto Dittmer", [class17 objectForKey:kInstructorName], @"Instructor name incorrect");
    
    startDate = (NSDate *)[class17 objectForKey:kStartDate];
    STAssertEqualObjects(@"8/17/11 7:30 PM", [dateFormatter stringFromDate:startDate], @"Start date incorrect");
    
    endDate = (NSDate *)[class17 objectForKey:kEndDate];
    STAssertEqualObjects(@"8/17/11 8:45 PM", [dateFormatter stringFromDate:endDate], @"End date incorrect");
    
    [dateFormatter release];
}

- (NSData *)classesXMLData {
    return [NSData dataWithContentsOfFile:kPathToClassesXML];
}

@end

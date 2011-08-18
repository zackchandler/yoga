#import "YogaTests.h"

static NSString * const kPathToClassesXML = @"/Users/zackchandler/dev/Yoga/YogaTests/query_classes_result.xml";

@interface YogaTests()

- (NSData *)classesXMLData;

@end

@implementation YogaTests

- (void)testParsingClassesXML {
    MindBodyParser *parser = [[MindBodyParser alloc] init];

    NSArray *klasses = [parser parseClassesXML:[self classesXMLData]];
    
//    NSLog(@"classes: %@", klasses);
    
    [parser release];
}

- (NSData *)classesXMLData {
    return [NSData dataWithContentsOfFile:kPathToClassesXML];
}

@end

#import "MindBodyParser.h"

@interface MindBodyParser()

- (NSDictionary *) parseFinderClassNode:(TBXMLElement *)node dateFormatter:(NSDateFormatter *)dateFormatter;

@end

@implementation MindBodyParser

- (NSArray *)parseClassesXML:(NSData *)xmlData {
    NSMutableArray *array = [NSMutableArray array];
    
    TBXML *tbxml = [[TBXML tbxmlWithXMLData:xmlData] retain];
    
    TBXMLElement *root = tbxml.rootXMLElement;
    if (!root) {
        return array;
    }
    
    TBXMLElement *soapBodyNode = [TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *getClassesWithinRadiusResponseNode = [TBXML childElementNamed:@"GetClassesWithinRadiusResponse" parentElement:soapBodyNode];
    TBXMLElement *getClassesWithinRadiusResultNode = [TBXML childElementNamed:@"GetClassesWithinRadiusResult" parentElement:getClassesWithinRadiusResponseNode];
    TBXMLElement *finderClassesNode = [TBXML childElementNamed:@"FinderClasses" parentElement:getClassesWithinRadiusResultNode];
    
    // FinderClass node
    TBXMLElement *finderClassNode = [TBXML childElementNamed:@"FinderClass" parentElement:finderClassesNode];
    if (finderClassNode) {
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:kMindBodyAPIDateFormat];
        
        do {
            NSDictionary *klass = [self parseFinderClassNode:finderClassNode dateFormatter:dateFormatter];
            [array addObject:klass];
        } while ((finderClassNode = finderClassNode->nextSibling));
    }
    
    [tbxml release];
    
    return array;
}

- (NSDictionary *) parseFinderClassNode:(TBXMLElement *)node dateFormatter:(NSDateFormatter *)dateFormatter {
    // Class name
    TBXMLElement *classNameNode = [TBXML childElementNamed:@"ClassName" parentElement:node];
    NSString *className = [TBXML textForElement:classNameNode];
    
    // Some classes in WC have the music entity tagged on (&amp;#9835;)
    className = [className stringByReplacingOccurrencesOfString:@"&amp;#9835;" withString:@""];
    className = [className stringByReplacingOccurrencesOfString:@"&amp;#9733;" withString:@""];
    
    // Instructor name
    TBXMLElement *staffNode = [TBXML childElementNamed:@"Staff" parentElement:node];
    TBXMLElement *staffNameNode = [TBXML childElementNamed:@"Name" parentElement:staffNode];
    NSString *staffName = [TBXML textForElement:staffNameNode];
    
    // Start time
    TBXMLElement *startDateTimeNode = [TBXML childElementNamed:@"StartDateTime" parentElement:node];
    NSString *startDateTimeString = [TBXML textForElement:startDateTimeNode];
    NSDate *startDateTime = [dateFormatter dateFromString:startDateTimeString];
    
    // End time
    TBXMLElement *endDateTimeNode = [TBXML childElementNamed:@"EndDateTime" parentElement:node];
    NSString *endDateTimeString = [TBXML textForElement:endDateTimeNode];
    NSDate *endDateTime = [dateFormatter dateFromString:endDateTimeString];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            className, kClassName,
            staffName, kInstructorName,
            startDateTime, kStartDate,
            endDateTime, kEndDate, nil];
}

@end

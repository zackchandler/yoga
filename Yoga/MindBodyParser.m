#import "MindBodyParser.h"

@interface MindBodyParser()

- (NSDictionary *) parseFinderClassNode:(TBXMLElement *)node;

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
        do {
            NSDictionary *klass = [self parseFinderClassNode:finderClassNode];
            [array addObject:klass];
        } while ((finderClassNode = finderClassNode->nextSibling));
    }
    
    [tbxml release];
    
    return array;
}

- (NSDictionary *) parseFinderClassNode:(TBXMLElement *)node {
    // ClassName
    TBXMLElement *classNameNode = [TBXML childElementNamed:@"ClassName" parentElement:node];
    NSString *className = [TBXML textForElement:classNameNode];
    NSLog(@"className: %@", className);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            className, kClassName, nil];
}

@end

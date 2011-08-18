#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface MindBodyParser : NSObject

- (NSArray *)parseClassesXML:(NSData *)xml;

@end

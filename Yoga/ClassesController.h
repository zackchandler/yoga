#import <UIKit/UIKit.h>

#import "ClassTableViewCell.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MindBodyParser.h"

@interface ClassesController : UITableViewController<UIAlertViewDelegate> {
	NSArray *classes;
    ASINetworkQueue *queue;
    MindBodyParser *parser;
}

@property (nonatomic, retain) NSArray *classes;
@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) MindBodyParser *parser;

@end

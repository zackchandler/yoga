#import "ClassTableViewCell.h"

@implementation ClassTableViewCell

@synthesize startDate;
@synthesize endDate;
@synthesize klassName;
@synthesize instructorName;

#define CLASS_TIME_X 5
#define CLASS_TIME_Y 8
#define CLASS_TIME_WIDTH 200
#define CLASS_TIME_FONT_SIZE 10

#define CLASS_NAME_X 110
#define CLASS_NAME_Y 5
#define CLASS_NAME_WIDTH 200
#define CLASS_NAME_FONT_SIZE 14

#define INSTRUCTOR_NAME_X 110
#define INSTRUCTOR_NAME_Y 24
#define INSTRUCTOR_NAME_WIDTH 200
#define INSTRUCTOR_NAME_FONT_SIZE 12

- (void)drawRect:(CGRect)rect {
	// draw class time
	[[UIColor darkGrayColor] set];
	CGPoint classTimePoint = CGPointMake(CLASS_TIME_X, CLASS_TIME_Y);
	UIFont *classTimeFont = [UIFont systemFontOfSize:CLASS_TIME_FONT_SIZE];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
	NSString *classTime = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]];
	NSLog(@"classTime: %@", classTime);
	[classTime drawAtPoint:classTimePoint forWidth:CLASS_TIME_WIDTH withFont:classTimeFont lineBreakMode:UILineBreakModeTailTruncation];
	
	// draw class name
	[[UIColor blackColor] set];
	CGPoint classNamePoint = CGPointMake(CLASS_NAME_X, CLASS_NAME_Y);
	UIFont *classNameFont = [UIFont systemFontOfSize:CLASS_NAME_FONT_SIZE];
	[self.klassName drawAtPoint:classNamePoint forWidth:CLASS_NAME_WIDTH withFont:classNameFont lineBreakMode:UILineBreakModeTailTruncation];
	
	// draw instructor name
	[[UIColor darkGrayColor] set];
	CGPoint instructorNamePoint = CGPointMake(INSTRUCTOR_NAME_X, INSTRUCTOR_NAME_Y);
	UIFont *instructorNameFont = [UIFont systemFontOfSize:INSTRUCTOR_NAME_FONT_SIZE];
	[self.instructorName drawAtPoint:instructorNamePoint forWidth:CLASS_NAME_WIDTH withFont:instructorNameFont lineBreakMode:UILineBreakModeTailTruncation];
}

- (void)dealloc {
	[startDate release];
	[endDate release];
	[klassName release];
	[instructorName release];
	
	[super dealloc];
}

@end

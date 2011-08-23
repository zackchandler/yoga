#import "ClassTableViewCell.h"

@implementation ClassTableViewCell

@synthesize startDate;
@synthesize endDate;
@synthesize klassName;
@synthesize instructorName;

#define PADDING 5

#define CLASS_TIME_X 5
#define CLASS_TIME_Y 8
#define CLASS_TIME_WIDTH 100
#define CLASS_TIME_FONT_SIZE 10

#define CLASS_NAME_X 115
#define CLASS_NAME_Y 5
#define CLASS_NAME_FONT_SIZE 14

#define INSTRUCTOR_NAME_X 115
#define INSTRUCTOR_NAME_Y 24
#define INSTRUCTOR_NAME_FONT_SIZE 12

- (void)drawRect:(CGRect)rect {
	// draw class time
	[[UIColor darkGrayColor] set];
	UIFont *classTimeFont = [UIFont systemFontOfSize:CLASS_TIME_FONT_SIZE];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
    
	NSString *classTime = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]];

    // Calculate for right alignment
    CGSize classTimeSize = [classTime sizeWithFont:classTimeFont forWidth:CLASS_TIME_WIDTH lineBreakMode:UILineBreakModeTailTruncation];
	CGPoint classTimePoint = CGPointMake(CLASS_TIME_X + CLASS_TIME_WIDTH - classTimeSize.width, CLASS_TIME_Y);

    [classTime drawAtPoint:classTimePoint forWidth:CLASS_TIME_WIDTH withFont:classTimeFont lineBreakMode:UILineBreakModeTailTruncation];
	
	// draw class name
	[[UIColor blackColor] set];
	CGPoint classNamePoint = CGPointMake(CLASS_NAME_X, CLASS_NAME_Y);
	UIFont *classNameFont = [UIFont systemFontOfSize:CLASS_NAME_FONT_SIZE];

    CGFloat classNameWidth = self.bounds.size.width - CLASS_TIME_WIDTH - CLASS_TIME_X - (2 * PADDING);
	[self.klassName drawAtPoint:classNamePoint forWidth:classNameWidth withFont:classNameFont lineBreakMode:UILineBreakModeTailTruncation];
	
	// draw instructor name
	[[UIColor darkGrayColor] set];
	CGPoint instructorNamePoint = CGPointMake(INSTRUCTOR_NAME_X, INSTRUCTOR_NAME_Y);
	UIFont *instructorNameFont = [UIFont systemFontOfSize:INSTRUCTOR_NAME_FONT_SIZE];

    CGFloat instructorNameWidth = self.bounds.size.width - CLASS_TIME_WIDTH - CLASS_TIME_X - (2 * PADDING);
	[self.instructorName drawAtPoint:instructorNamePoint forWidth:instructorNameWidth withFont:instructorNameFont lineBreakMode:UILineBreakModeTailTruncation];
}

- (void)dealloc {
	[startDate release];
	[endDate release];
	[klassName release];
	[instructorName release];
	
	[super dealloc];
}

@end

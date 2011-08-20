#import "ClassesController.h"

static NSString *kClassesXMLFileName = @"classes.xml";
static NSString *kErrorFetchingClassesTitle = @"Sorry...";
static NSString *kErrorFetchingClassesMessage = @"Unable to refresh classes list";

@interface ClassesController()

- (void)refreshClassesFromAPI;
- (void)refreshClassesFromCachedFile;
- (NSString *)classesFilePath;

@end

@implementation ClassesController

@synthesize classes;
@synthesize queue;
@synthesize parser;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.title = kClassesControllerTitle;
    self.tableView.allowsSelection = NO;
	
    [self refreshClassesFromCachedFile];
    [self refreshClassesFromAPI];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.classes count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *classesForDay = [self.classes objectAtIndex:section];
    NSDictionary *aClass = [classesForDay lastObject];
    NSDate *startDate = [aClass objectForKey:kStartDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    NSString *dateString = [dateFormatter stringFromDate:startDate];

    [dateFormatter release];
    
    return dateString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *classesForDay = [self.classes objectAtIndex:section];
    return [classesForDay count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[ClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    NSArray *classesForDay = [self.classes objectAtIndex:indexPath.section];
	NSDictionary *klass = [classesForDay objectAtIndex:indexPath.row];
	
	cell.klassName = [klass objectForKey:kClassName];
	cell.instructorName = [klass objectForKey:kInstructorName];
	cell.startDate = [klass objectForKey:kStartDate];
	cell.endDate = [klass objectForKey:kEndDate];
	
	// Why do we need this when using dequeueReusableCellWithIdentifier??? - strange
	[cell setNeedsDisplay];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate


#pragma mark -
#pragma mark Network

- (void)refreshClassesFromAPI {
    NSURL *url = [NSURL URLWithString:kMindBodyFetchClassesURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request addRequestHeader:@"Content-Type" value:@"text/xml;charset=UTF-8"];
    [request addRequestHeader:@"Soapaction" value:@"http://clients.mindbodyonline.com/api/0_5/GetClassesWithinRadius"];
    
    NSString *queryClassesTemplateFilePath = [[NSBundle mainBundle] pathForResource:@"QueryClassesTemplate" ofType:@"xml"];
    NSString *postString = [NSString stringWithContentsOfFile:queryClassesTemplateFilePath encoding:NSUTF8StringEncoding error:nil];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    // Five days from now
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:(60*60*24*5)];
    NSString *startDateString = [dateFormatter stringFromDate:today];
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    [dateFormatter release];
    
    postString = [postString stringByReplacingOccurrencesOfString:@"{{StartDateTime}}" withString:startDateString];
    postString = [postString stringByReplacingOccurrencesOfString:@"{{EndDateTime}}" withString:endDateString];
    
    NSData *postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setPostBody:[NSMutableData dataWithData:postBody]];
    
    [request setDownloadDestinationPath:[self classesFilePath]];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSucceeded:)];
    [request setDidFailSelector:@selector(requestFailed:)];
 
    [self.queue addOperation:request];
}

- (void)requestSucceeded:(ASIHTTPRequest *)request {    
    [self refreshClassesFromCachedFile];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kErrorFetchingClassesTitle message:kErrorFetchingClassesMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    [alertView release];
}

- (void)refreshClassesFromCachedFile {
    // Move parsing off main thread?
    NSData *xmlData = [NSData dataWithContentsOfFile:[self classesFilePath]];
    NSArray *rawClassList = [self.parser parseClassesXML:xmlData];
    
    if ([rawClassList count] > 0) {
        // Build data structure which is an Array of array of classes
        // [
        //   [ class, class ],
        //   [ class, class ]
        // ]
        NSMutableArray *allClasses = [NSMutableArray array];
        
        // Compare dates as strings because it is clean and simple
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        
        NSString *currentDay = @"";
        NSMutableArray *classesForCurrentDayArray;
        
        for (NSDictionary *klass in rawClassList) {
            NSDate *startDate = [klass objectForKey:kStartDate];
            NSString *dateString = [dateFormatter stringFromDate:startDate];
            
            if ([dateString isEqualToString:currentDay]) {
                // append class
                [classesForCurrentDayArray addObject:klass];
            } else {
                currentDay = dateString;
                // create array, add class, and add to class list
                classesForCurrentDayArray = [NSMutableArray arrayWithObject:klass];
                [allClasses addObject:classesForCurrentDayArray];
            }
        }
        
        [dateFormatter release];
        
        self.classes = allClasses;
    } else {
        self.classes = [NSMutableArray array];
    }
    
    [self.tableView reloadData];
}

- (NSString *)classesFilePath {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentsDirectory stringByAppendingPathComponent:kClassesXMLFileName];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark -
#pragma mark Lazy Initialization Getters

- (ASINetworkQueue *)queue {
    if (!queue) {
        ASINetworkQueue *aQueue = [[ASINetworkQueue alloc] init];
        aQueue.maxConcurrentOperationCount = 1;
        self.queue = aQueue;
        [aQueue release];
        
        // Instruct queue to run requests as they enter
        [self.queue go];
    }
    
    return queue;
}

- (MindBodyParser *)parser {
    if (!parser) {
        MindBodyParser *aParser = [[MindBodyParser alloc] init];
        self.parser = aParser;
        [aParser release];
    }
    
    return parser;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[classes release];
    [queue release];
    [parser release];
    
    [super dealloc];
}

@end


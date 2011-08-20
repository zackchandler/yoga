#import "ClassesController.h"

static NSString *kClassesXMLFileName = @"classes.xml";
static NSString *kErrorFetchingClassesTitle = @"Sorry...";
static NSString *kErrorFetchingClassesMessage = @"Unable to refresh classes list";

@interface ClassesController()

- (void)refreshClasses;
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
    
    self.tableView.allowsSelection = NO;
	
    [self refreshClasses];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.classes count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[ClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	NSDictionary *klass = [self.classes objectAtIndex:indexPath.row];
	
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

- (void)refreshClasses {
    NSURL *url = [NSURL URLWithString:kMindBodyFetchClassesURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request addRequestHeader:@"Content-Type" value:@"text/xml;charset=UTF-8"];
    [request addRequestHeader:@"Soapaction" value:@"http://clients.mindbodyonline.com/api/0_5/GetClassesWithinRadius"];
    
    NSString *queryClassesTemplateFilePath = [[NSBundle mainBundle] pathForResource:@"QueryClassesTemplate" ofType:@"xml"];
    NSMutableData *postBody = [NSMutableData dataWithContentsOfFile:queryClassesTemplateFilePath];
    [request setPostBody:postBody];
    
    [request setDownloadDestinationPath:[self classesFilePath]];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSucceeded:)];
    [request setDidFailSelector:@selector(requestFailed:)];
 
    [self.queue addOperation:request];
}

- (void)requestSucceeded:(ASIHTTPRequest *)request {
    NSString *response = [request responseString];
    
    // Move parsing off main thread?
    NSData *xmlData = [NSData dataWithContentsOfFile:[self classesFilePath]];
    self.classes = [self.parser parseClassesXML:xmlData];

    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kErrorFetchingClassesTitle message:kErrorFetchingClassesMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    [alertView release];
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


#import "ClassesController.h"

@implementation ClassesController

@synthesize klasses;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSDictionary *klass1 = [NSDictionary dictionaryWithObjectsAndKeys:
							@"Vinyasa Flow", kClassName,
							@"Jamie McMaster", kInstructorName,
							[NSDate dateWithTimeIntervalSinceReferenceDate:118800], kStartDate,
							[NSDate dateWithTimeIntervalSinceReferenceDate:118900], kEndDate,
							nil];
	NSDictionary *klass2 = [NSDictionary dictionaryWithObjectsAndKeys:
							@"Pilates", kClassName,
							@"Sonia Roberts", kInstructorName,
							[NSDate date], kStartDate,
							[NSDate date], kEndDate,
							nil];
	NSDictionary *klass3 = [NSDictionary dictionaryWithObjectsAndKeys:
							@"Bikram", kClassName,
							@"Adi Amar", kInstructorName,
							[NSDate date], kStartDate,
							[NSDate date], kEndDate,
							nil];
	NSDictionary *klass4 = [NSDictionary dictionaryWithObjectsAndKeys:
							@"Intermediate Reformer / Group (Pre-Reg Req)", kClassName,
							@"A really long instructor name & Adi Amar", kInstructorName,
							[NSDate date], kStartDate,
							[NSDate date], kEndDate,
							nil];
	
	self.klasses = [NSArray arrayWithObjects:klass1, klass2, klass3, klass4, nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.klasses count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[ClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	NSDictionary *klass = [self.klasses objectAtIndex:indexPath.row];
	NSLog(@"%@", klass);
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[klasses release];
    [super dealloc];
}

@end


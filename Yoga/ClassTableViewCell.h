@interface ClassTableViewCell : UITableViewCell {
	NSDate *startDate;
	NSDate *endDate;
	NSString *klassName;
	NSString *instructorName;
}

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSString *klassName;
@property (nonatomic, retain) NSString *instructorName;

@end

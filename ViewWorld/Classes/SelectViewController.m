    //
//  SelectViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "SelectViewController.h"


@implementation SelectViewController

@synthesize _tableView;
@synthesize tableViewItems;
@synthesize selectionArray;

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	/*for(NSString *string in selectionArray){
		NSLog(@"%@", string);
	}*/
	thisEntry.itemEntries = selectionArray;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//selectionArray = [[NSMutableArray alloc] init];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, 320, 287) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	self.tableViewItems = thisEntry.items;
	self.selectionArray = [thisEntry.itemEntries mutableCopy];
	
	[self.view addSubview:_tableView];
	
    [super viewDidLoad];
}

- (void)dealloc {
	[selectionArray release];
	[_tableView release];
	[tableViewItems release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [tableViewItems count];	
}

-(UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	NSUInteger row = [indexPath row];
	
	
	UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil){
		CGRect cellFrame = CGRectZero;
		cell = [[[UITableViewCell alloc] initWithFrame:cellFrame reuseIdentifier: nil] autorelease];
		
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	NSDictionary *item = [tableViewItems objectAtIndex:row];
	
	cell.textLabel.text = [item objectForKey:@"itemLabel"];
	
	
	
	if ([selectionArray containsObject:[item objectForKey:@"itemValue"]]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	NSDictionary *item = [tableViewItems objectAtIndex:row];
	//NSLog(@"value: %@", [item objectForKey:@"itemValue"]);
	
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[selectionArray addObject:[item objectForKey:@"itemValue"]];
	}else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		[selectionArray removeObject:[item objectForKey:@"itemValue"]];
	}
	
	
}

@end

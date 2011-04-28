    //
//  Select1ViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "Select1ViewController.h"

@implementation Select1ViewController

@synthesize _tableView;
@synthesize items;
@synthesize lastSelectedValue;
@synthesize startSelectedCell;

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	//NSLog(@"%@", lastSelectedValue);
	thisEntry.entryString = lastSelectedValue;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, 320, 287) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	self.items = thisEntry.items;
	self.lastSelectedValue = thisEntry.entryString;
	
	[self.view addSubview:_tableView];
	
    [super viewDidLoad];
}

- (void)dealloc {
	[startSelectedCell release];
	[lastSelectedValue release];
	[_tableView release];
	[items release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [items count];	
}

-(UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	NSUInteger row = [indexPath row];
	
	UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil){
		CGRect cellFrame = CGRectZero;
		cell = [[[UITableViewCell alloc] initWithFrame:cellFrame reuseIdentifier: nil] autorelease];
		
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	NSDictionary *item = [items objectAtIndex:row];
	
	cell.textLabel.text = [item objectForKey:@"itemLabel"];
	
	
	
	return cell;
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *thisCell = [_tableView cellForRowAtIndexPath:indexPath];
	if (self.startSelectedCell != nil && thisCell != self.startSelectedCell) {
		//NSLog(@"her");
		[self.startSelectedCell setSelected:NO];
		self.startSelectedCell = nil;
	}
	NSInteger row = [indexPath row];
	//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	NSDictionary *item = [items objectAtIndex:row];
	//NSLog(@"value: %@", [item objectForKey:@"itemValue"]);
	self.lastSelectedValue = [item objectForKey:@"itemValue"];
	
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
	NSDictionary *item = [items objectAtIndex:row];
	
	if ([[item objectForKey:@"itemValue"] isEqualToString:lastSelectedValue]) {
		[cell setSelected:YES];
		self.startSelectedCell = cell;
	}
}

@end

/*
 * Copyright (C) 2011 ViewWorld Aps.
 *
 * This file is part of the ViewWorld iPhone application.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
 *
 */

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

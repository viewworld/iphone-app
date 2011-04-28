    //
//  FinishedReportsViewController.m
//  ViewWorld
//
//  Created by Daniel Kold on 1/25/11.
//  Copyright 2011 Ncouraged. All rights reserved.
//

#import "FinishedReportsViewController.h"
#import "ViewWorldAppDelegate.h"
#import "Report.h"

@implementation FinishedReportsViewController

@synthesize _tableView;
@synthesize reportsArray;
@synthesize isFinished;

-(void)editButtonPressed{
	[_tableView setEditing:!_tableView.editing];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)loadView {
	UIView *view = [[UIView alloc] init];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonPressed)];
	self.navigationItem.rightBarButtonItem = editButton;
	[editButton release];
	
	[view addSubview:_tableView];
	
	self.view = view;
	[view release];
	
}

-(void)viewWillAppear:(BOOL)animated{
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == %@", [NSNumber numberWithBool:isFinished]];
	self.reportsArray = [[delegate.reports filteredArrayUsingPredicate:predicate] mutableCopy];
	
	if (isFinished) {
		NSLog(@"finished report count %d", [reportsArray count]);
	}else {
		NSLog(@"unfinished report count %d", [reportsArray count]);
	}

	
	
	[_tableView reloadData];
	
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[reportsArray release];
	[_tableView release];
    [super dealloc];
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [reportsArray count];	
}

-(UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	NSUInteger row = [indexPath row];
	
	UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil){
		CGRect cellFrame = CGRectZero;//CGRectMake(0, 0, 320, 70);
		cell = [[[UITableViewCell alloc] initWithFrame:cellFrame reuseIdentifier: nil] autorelease];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	Report *report = [reportsArray objectAtIndex:row];
	
	cell.textLabel.text = report.title;
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (isFinished) {
		return @"Finished forms";
	}else {
		return @"Unfinished forms";
	}

	
}

- (void)tableView:(UITableView *)tempTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSLog(@"delete");
	NSInteger row = [indexPath row];
	
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	Report *thisReport = [reportsArray objectAtIndex:row];
	[reportsArray removeObjectAtIndex:row];
	[delegate.reports removeObject:thisReport];
	
	[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
	Report *thisReport = [reportsArray objectAtIndex:row];
	//NSLog(@"title %@ num entries: %d location string %@", thisReport.title, [thisReport.entries count], [[thisReport.entries objectAtIndex:0] entryString]);
	TitleViewController *titleVC = [[TitleViewController alloc] initWithReport:thisReport andIndex:0];
	titleVC.title = @"Set title";
	[self.navigationController pushViewController:titleVC animated:YES];
	[titleVC release];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleDelete;//UITableViewCellEditingStyleNone;
}

@end

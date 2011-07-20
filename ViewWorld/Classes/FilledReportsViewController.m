    //
//  FinishedReportsViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/25/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "FilledReportsViewController.h"
#import "ViewWorldAppDelegate.h"
#import "Report.h"
#import "FlurryAPI.h"

@implementation FilledReportsViewController

@synthesize _tableView;
@synthesize reportsArray;
@synthesize isFinished;

-(void)presentFirstEntry:(Report *)currentReport{
	if([currentReport.entries count] > 0){
		Entry *thisEntry = [currentReport.entries objectAtIndex:0];
		NSString *type = nil;
		NSString *typeFromBindDic = [currentReport.bindDic objectForKey:thisEntry.type];
		if (typeFromBindDic == nil) {
			type = thisEntry.type;
		}else if([typeFromBindDic isEqualToString:@"binary"]){
			type = [currentReport.bindDic objectForKey:[NSString stringWithFormat:@"%@binary", thisEntry.type]];
		}else{
            type = typeFromBindDic;
        }
		
		if ([type isEqualToString:@"string"]) {
			StringViewController *stringVC = [[StringViewController alloc] initWithReport:currentReport andIndex:0];
			stringVC.title = NSLocalizedString(@"String" ,@"stringVC_title");
			[self.navigationController pushViewController:stringVC animated:YES];
			[stringVC release];
		}else if([type isEqualToString:@"int"]){
			IntViewController *intVC = [[IntViewController alloc] initWithReport:currentReport andIndex:0];
			intVC.title = NSLocalizedString(@"Integer" ,@"intVC_title");
			[self.navigationController pushViewController:intVC animated:YES];
			[intVC release];
		}else if([type isEqualToString:@"decimal"]){
			DecimalViewController *decVC = [[DecimalViewController alloc] initWithReport:currentReport andIndex:0];
			decVC.title = NSLocalizedString(@"Decimal" ,@"decVC_title");
			[self.navigationController pushViewController:decVC animated:YES];
			[decVC release];
		}else if ([type isEqualToString:@"date"]) {
			DateViewController *dateVC = [[DateViewController alloc] initWithReport:currentReport andIndex:0];
			dateVC.title = NSLocalizedString(@"Date" ,@"dateVC_title");
			[self.navigationController pushViewController:dateVC animated:YES];
			[dateVC release];
		}else if ([type isEqualToString:@"dateTime"]) {
			DateViewController *dateTimeVC = [[DateViewController alloc] initWithReport:currentReport andIndex:0];
			dateTimeVC.title = NSLocalizedString(@"Date and time" ,@"dateTimeVC_title");
			[self.navigationController pushViewController:dateTimeVC animated:YES];
			[dateTimeVC release];
		}else if ([type isEqualToString:@"select"]) {
			SelectViewController *selectVC = [[SelectViewController alloc] initWithReport:currentReport andIndex:0];
			selectVC.title = NSLocalizedString(@"Select multiple" ,@"selectVC_title");
			[self.navigationController pushViewController:selectVC animated:YES];
			[selectVC release];
		}else if ([type isEqualToString:@"select1"]) {
			Select1ViewController *select1VC = [[Select1ViewController alloc] initWithReport:currentReport andIndex:0];
			[self.navigationController pushViewController:select1VC animated:YES];
			select1VC.title = NSLocalizedString(@"Select one" ,@"select1VC_title");
			[select1VC release];
		}else if ([type isEqualToString:@"geopoint"]) {
			GPSViewController *gpsVC = [[GPSViewController alloc] initWithReport:currentReport andIndex:0];
			gpsVC.title = NSLocalizedString(@"GPS" ,@"gpsVC_title");
			[self.navigationController pushViewController:gpsVC animated:YES];
			[gpsVC release];
		}else if ([type isEqualToString:@"imageType"]) {
			ImageViewController *imageVC = [[ImageViewController alloc] initWithReport:currentReport andIndex:0];
			imageVC.title = NSLocalizedString(@"Image" ,@"imageVC_title");
			[self.navigationController pushViewController:imageVC animated:YES];
			[imageVC release];
		}else if ([type isEqualToString:@"audioType"]) {
			AudioViewController *audioVC = [[AudioViewController alloc] initWithReport:currentReport andIndex:0];
			audioVC.title = NSLocalizedString(@"Audio" ,@"audioVC_title");
			[self.navigationController pushViewController:audioVC animated:YES];
			[audioVC release];
		}else if ([type isEqualToString:@"videoType"]) {
			VideoViewController *videoVC = [[VideoViewController alloc] initWithReport:currentReport andIndex:0];
			videoVC.title = NSLocalizedString(@"Video" ,@"videoVC_title");
			[self.navigationController pushViewController:videoVC animated:YES];
			[videoVC release];
		}else {
			UnknownObjectViewController *ukVC = [[UnknownObjectViewController alloc] initWithReport:currentReport andIndex:0];
			ukVC.title = NSLocalizedString(@"Unknown Type" ,@"ukVC_title");
			[self.navigationController pushViewController:ukVC animated:YES];
			[ukVC release];
		}
	}else {
		FormDoneViewController *formDoneVC = [[FormDoneViewController alloc] init];
		formDoneVC.currentReport = currentReport;
		formDoneVC.title = NSLocalizedString(@"Done" ,@"formDoneVC_title");
		[self.navigationController pushViewController:formDoneVC animated:YES];
		[formDoneVC release];
	}
}

-(void)editButtonPressed{
	[_tableView setEditing:!_tableView.editing];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)loadView {
	UIView *view = [[UIView alloc] init];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"editButton") style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonPressed)];
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
	
	/*if (isFinished) {
		NSLog(@"finished report count %d", [reportsArray count]);
	}else {
		NSLog(@"unfinished report count %d", [reportsArray count]);
	}*/

	[_tableView reloadData];
	
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
}


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
		return NSLocalizedString(@"Finished forms", @"filledReportsViewController_section_header_finished_forms");
	}else {
		return NSLocalizedString(@"Unfinished forms", @"filledReportsViewController_section_header_unfinished_forms");
	}

	
}

- (void)tableView:(UITableView *)tempTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	[FlurryAPI logEvent:@"report_deleted"];
	NSInteger row = [indexPath row];
	
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	Report *thisReport = [reportsArray objectAtIndex:row];
	[reportsArray removeObjectAtIndex:row];
	[delegate.reports removeObject:thisReport];
	[delegate archiveReports];
	
	[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[FlurryAPI logEvent:@"started_editing_report"];
	NSInteger row = [indexPath row];
	Report *thisReport = [reportsArray objectAtIndex:row];
	//NSLog(@"title %@ num entries: %d location string %@", thisReport.title, [thisReport.entries count], [[thisReport.entries objectAtIndex:0] entryString]);
	
    /*TitleViewController *titleVC = [[TitleViewController alloc] initWithReport:thisReport andIndex:0];
	titleVC.title = @"Set title";
	[self.navigationController pushViewController:titleVC animated:YES];
	[titleVC release];*/
    [self presentFirstEntry:thisReport];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleDelete;//UITableViewCellEditingStyleNone;
}

@end

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

#import "FilledReportsViewController.h"
#import "ViewWorldAppDelegate.h"
#import "Report.h"

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
			stringVC.title = @"String";
			[self.navigationController pushViewController:stringVC animated:YES];
			[stringVC release];
		}else if([type isEqualToString:@"int"]){
			IntViewController *intVC = [[IntViewController alloc] initWithReport:currentReport andIndex:0];
			intVC.title = @"Integer";
			[self.navigationController pushViewController:intVC animated:YES];
			[intVC release];
		}else if([type isEqualToString:@"decimal"]){
			DecimalViewController *decVC = [[DecimalViewController alloc] initWithReport:currentReport andIndex:0];
			decVC.title = @"Decimal";
			[self.navigationController pushViewController:decVC animated:YES];
			[decVC release];
		}else if ([type isEqualToString:@"date"]) {
			DateViewController *dateVC = [[DateViewController alloc] initWithReport:currentReport andIndex:0];
			dateVC.title = @"Date";
			[self.navigationController pushViewController:dateVC animated:YES];
			[dateVC release];
		}else if ([type isEqualToString:@"dateTime"]) {
			DateViewController *dateTimeVC = [[DateViewController alloc] initWithReport:currentReport andIndex:0];
			dateTimeVC.title = @"Date and time";
			[self.navigationController pushViewController:dateTimeVC animated:YES];
			[dateTimeVC release];
		}else if ([type isEqualToString:@"select"]) {
			SelectViewController *selectVC = [[SelectViewController alloc] initWithReport:currentReport andIndex:0];
			selectVC.title = @"Select multiple";
			[self.navigationController pushViewController:selectVC animated:YES];
			[selectVC release];
		}else if ([type isEqualToString:@"select1"]) {
			Select1ViewController *select1VC = [[Select1ViewController alloc] initWithReport:currentReport andIndex:0];
			[self.navigationController pushViewController:select1VC animated:YES];
			select1VC.title = @"Select one";
			[select1VC release];
		}else if ([type isEqualToString:@"geopoint"]) {
			GPSViewController *gpsVC = [[GPSViewController alloc] initWithReport:currentReport andIndex:0];
			gpsVC.title = @"GPS";
			[self.navigationController pushViewController:gpsVC animated:YES];
			[gpsVC release];
		}else if ([type isEqualToString:@"imageType"]) {
			ImageViewController *imageVC = [[ImageViewController alloc] initWithReport:currentReport andIndex:0];
			imageVC.title = @"Image";
			[self.navigationController pushViewController:imageVC animated:YES];
			[imageVC release];
		}else if ([type isEqualToString:@"audioType"]) {
			AudioViewController *audioVC = [[AudioViewController alloc] initWithReport:currentReport andIndex:0];
			audioVC.title = @"Audio";
			[self.navigationController pushViewController:audioVC animated:YES];
			[audioVC release];
		}else if ([type isEqualToString:@"videoType"]) {
			VideoViewController *videoVC = [[VideoViewController alloc] initWithReport:currentReport andIndex:0];
			videoVC.title = @"Video";
			[self.navigationController pushViewController:videoVC animated:YES];
			[videoVC release];
		}else {
			UnknownObjectViewController *ukVC = [[UnknownObjectViewController alloc] initWithReport:currentReport andIndex:0];
			ukVC.title = @"Unknown Type";
			[self.navigationController pushViewController:ukVC animated:YES];
			[ukVC release];
		}
	}else {
		FormDoneViewController *formDoneVC = [[FormDoneViewController alloc] init];
		formDoneVC.currentReport = currentReport;
		formDoneVC.title = @"Done";
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
		return @"Finished forms";
	}else {
		return @"Unfinished forms";
	}

	
}

- (void)tableView:(UITableView *)tempTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
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

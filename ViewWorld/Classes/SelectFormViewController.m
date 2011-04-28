    //
//  SelectFormViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/4/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "SelectFormViewController.h"
#import "FormParserOperation.h"
#import "ViewWorldAppDelegate.h"
#import "FlurryAPI.h"


@implementation SelectFormViewController

@synthesize _tableView;
@synthesize forms;
@synthesize lastSelected;
@synthesize noFormsLabel;
@synthesize parsedTitle;

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

-(void)doneParsing:(Report *)parsedReport{	
	if([parsedReport.entries count] > 0){		
		/*TitleViewController *titleVC = [[TitleViewController alloc] initWithReport:parsedReport andIndex:0];
		titleVC.title = @"Set title";
		[self.navigationController pushViewController:titleVC animated:YES];
		[titleVC release];*/
		[self presentFirstEntry:parsedReport];
	}else{
		NSLog(@"no data in form");
		//[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonPressed)];
	self.navigationItem.rightBarButtonItem = editButton;
	[editButton release];
	
	self.title = @"New Report";
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	noFormsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 50)];
	noFormsLabel.backgroundColor = [UIColor clearColor];
	noFormsLabel.text = @"No forms available. Download new forms in the \"Manage\" tab.";
	noFormsLabel.numberOfLines = 2;
	
	[view addSubview:_tableView];
	[view addSubview:noFormsLabel];
	
	self.view = view;
	[view release];
}

-(void)viewWillAppear:(BOOL)animated{
	/*if(self.lastSelected){
		[self.lastSelected setSelected:NO animated:YES];
		self.lastSelected = nil;
	}*/
	
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	self.forms = delegate.formListArray;
	
	if ([forms count] == 0) {
		_tableView.hidden = YES;
		noFormsLabel.hidden = NO;
	}else {
		_tableView.hidden = NO;
		noFormsLabel.hidden = YES;
	}
	
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
	[noFormsLabel release];
	[_tableView release];
	[forms release];
	[lastSelected release];
	//[parsedTitle release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate.reports count] > 0) {
		return 2;
	}else{
		return 1;
	}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0) {
		return [forms count];
	}else if(section == 1) {
		ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		return [delegate.reports count];
	}
	return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	NSUInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil){
		CGRect cellFrame = CGRectZero;//CGRectMake(0, 0, 320, 70);
		cell = [[[UITableViewCell alloc] initWithFrame:cellFrame reuseIdentifier: nil] autorelease];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if (section == 0) {
		NSDictionary *form = [forms objectAtIndex:row];
		cell.textLabel.text = [form	objectForKey:@"title"];
	}else if(section == 1){
		ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		Report *thisReport = [delegate.reports objectAtIndex:row];
		cell.textLabel.text = thisReport.title;
	}

	
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return @"Select form";
	}else if(section == 1){
		return @"Use form as template";
	}	
	return nil;
}

- (void)tableView:(UITableView *)tempTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	[FlurryAPI logEvent:@"form_deleted"];
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	if (section == 0) {
		ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.formListArray removeObjectAtIndex:row];
		[delegate.formListArray writeToFile:[delegate formListFilePath] atomically:YES];
		
		[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[FlurryAPI logEvent:@"starting_new_report"];
	
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
   	//self.lastSelected = [tableView cellForRowAtIndexPath:indexPath];
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if (section == 0) {		
		NSDictionary *form = [forms objectAtIndex:row];	
		NSData *savedFormData = [[NSData alloc] initWithContentsOfFile:[delegate filePathForFormWithTitle:[form objectForKey:@"title"]]];
		
		FormParserOperation *operation = [[FormParserOperation alloc] init];
		operation.formData = savedFormData;
		
		[delegate.queue addOperation:operation];
		[operation release];
	}else if(section == 1){
		Report *thisReport = [delegate.reports objectAtIndex:row];
		Report *newReport = [[Report alloc] init];
		NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:thisReport.entries copyItems:YES];
		newReport.entries = newArray;
		[newArray release];
		newReport.bindDic = [thisReport.bindDic copy];
		newReport.title = [thisReport.title copy];
        newReport.origTitle = [thisReport.origTitle copy];
		newReport.dataId = [thisReport.dataId copy];
		/*TitleViewController *titleVC = [[TitleViewController alloc] initWithReport:newReport andIndex:0];
		titleVC.title = @"Set title";
		[self.navigationController pushViewController:titleVC animated:YES];
		[titleVC release];*/
		[self presentFirstEntry:newReport];
		[newReport release];
	}

	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger section = [indexPath section];
	if (section == 0) {
		return UITableViewCellEditingStyleDelete;//UITableViewCellEditingStyleNone;
	}else {
		return UITableViewCellEditingStyleNone;
	}
	
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger section = [indexPath section];
	if(section == 0){
		return YES;
	}
	return NO;
}

@end

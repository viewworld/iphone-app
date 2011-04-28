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

#import "TitleViewController.h"


@implementation TitleViewController

@synthesize data, currentReport, titleTextField;

-(void)addValue{
	currentReport.title = titleTextField.text;
}

-(void)goToEndButtonPressed{
	[self addValue];
	FormDoneViewController *formDoneVC = [[FormDoneViewController alloc] init];
	formDoneVC.currentReport = currentReport;
	formDoneVC.title = @"Done";
	[self.navigationController pushViewController:formDoneVC animated:YES];
	[formDoneVC release];
}

-(void)backgroundClicked{
	[titleTextField resignFirstResponder];
}

-(void)nextButtonPressed{
	[self addValue];
	if([currentReport.entries count] > 0){
		Entry *thisEntry = [currentReport.entries objectAtIndex:0];
		NSString *type = nil;
		if ([currentReport.bindDic objectForKey:thisEntry.type] == nil) {
			type = thisEntry.type;
		}else {
			type = [currentReport.bindDic objectForKey:thisEntry.type];
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
		}else if ([type isEqualToString:@"binary"]) {
			ImageViewController *imageVC = [[ImageViewController alloc] initWithReport:currentReport andIndex:0];
			imageVC.title = @"Image";
			[self.navigationController pushViewController:imageVC animated:YES];
			[imageVC release];
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

//-(id)initWithArray:(NSArray *)dataArray andIndex:(int)dataIndex andReport:(Report *)report{
-(id)initWithReport:(Report *)report andIndex:(int)dataIndex{
	if ([self init]) {
		//self.data = dataArray;
		index = dataIndex;
		self.currentReport = report;
		
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	/*UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonPressed)];
	self.navigationItem.rightBarButtonItem = nextButton;
	[nextButton release];*/
	
	UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
	UIButton *endButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	endButton.frame	= CGRectMake(0, 7, 60, 29);
	[endButton addTarget:self action:@selector(goToEndButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	//[endButton setTitle:@"End" forState:UIControlStateNormal];
	[endButton setImage:[UIImage imageNamed:@"gotoendbutton.png"] forState:UIControlStateNormal];
	[barView addSubview:endButton];
	UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	nextButton.frame = CGRectMake(70, 7, 60, 29);
	//[nextButton setTitle:@"Next" forState:UIControlStateNormal];
	[nextButton setImage:[UIImage imageNamed:@"nextbutton.png"] forState:UIControlStateNormal];
	[nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[barView addSubview:nextButton];
	
	UIBarButtonItem *rightBarButtons = [[UIBarButtonItem alloc] initWithCustomView:barView];
	self.navigationItem.rightBarButtonItem = rightBarButtons;
	[rightBarButtons release];
	[barView release];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.text = @"Set a title for this report";
	
	titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 300, 30)];
	titleTextField.borderStyle = UITextBorderStyleRoundedRect;
	titleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	titleTextField.text = currentReport.title;
	titleTextField.delegate = self;
	[titleTextField becomeFirstResponder];
	
	UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
	bgButton.frame = CGRectMake(0, 0, 320, 367);
	[bgButton addTarget:self action:@selector(backgroundClicked) forControlEvents:UIControlEventTouchUpInside];
	
	[view addSubview:bgButton];
	
	[view addSubview:titleLabel];
	[view addSubview:titleTextField];
	
	[titleLabel release];
	
	self.view = view;
	[view release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	/*NSLog(@"Num entries %d", [currentReport.entries count]);
	for(Entry *ent in currentReport.entries){
		NSLog(@"entryString - %@", ent.entryString);
	}*/
	
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
	[titleTextField release];
	[data release];
	[currentReport release];
    [super dealloc];
}

#pragma mark TextField Delegate Methods

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 return YES;
 }*/

/*- (void)textFieldDidBeginEditing:(UITextField *)textField{
 
 [self selectColorButtonPressed];
 }*/


//- (void)textFieldDidEndEditing:(UITextField *)textField{
/*
 CGRect viewFrame = self.frame;
 viewFrame.origin.y += animatedDistance;
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
 
 [self setFrame:viewFrame];
 
 [UIView commitAnimations];
 */
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	currentReport.title = textField.text;
	[textField resignFirstResponder];
    return YES;
}

@end

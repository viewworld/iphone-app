    //
//  BaseEntryViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "BaseEntryViewController.h"

@implementation BaseEntryViewController

@synthesize label;
@synthesize hint;

@synthesize data;

@synthesize currentReport;

@synthesize  validated;

-(void)addValue{
	NSLog(@"super");
}

-(void)backButtonPressed{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"You are about to leave a new report without saving it. All entered data will be lost. Are you sure you want to leave the report?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Leave report", nil];
    [alert show];
    [alert release];
}

-(void)notValidatedAlert{
    //NSLog(@"not validated");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a decimal!" message:@"You have not entered a valid decimal number. The valid decimal seperator is the period/'dot' (.) symbol." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)goToEndButtonPressed{
	[self addValue];
    if (validated) {
        FormDoneViewController *formDoneVC = [[FormDoneViewController alloc] init];
        formDoneVC.currentReport = currentReport;
        formDoneVC.title = @"Done";
        [self.navigationController pushViewController:formDoneVC animated:YES];
        [formDoneVC release];
    }else  {
        [self notValidatedAlert];
    }
}

-(void)nextButtonPressed{
	[self addValue];
	if(([currentReport.entries count] > index+1) && self.validated){
		Entry *nextEntry = [currentReport.entries objectAtIndex:index+1];
		NSString *type = nil;
        NSString *typeFromBindDic = [currentReport.bindDic objectForKey:nextEntry.type];
		if (typeFromBindDic == nil) {
			type = nextEntry.type;
		}else if([typeFromBindDic isEqualToString:@"binary"]){
			type = [currentReport.bindDic objectForKey:[NSString stringWithFormat:@"%@binary", nextEntry.type]];
		}else{
            type = typeFromBindDic;
        }
        
		if ([type isEqualToString:@"string"]) {
			StringViewController *stringVC = [[StringViewController alloc] initWithReport:currentReport andIndex:index+1];
			stringVC.title = @"String";
			[self.navigationController pushViewController:stringVC animated:YES];
			[stringVC release];
		}else if([type isEqualToString:@"int"]){
			IntViewController *intVC = [[IntViewController alloc] initWithReport:currentReport andIndex:index+1];
			intVC.title = @"Integer";
			[self.navigationController pushViewController:intVC animated:YES];
			[intVC release];
		}else if([type isEqualToString:@"decimal"]){
			DecimalViewController *decVC = [[DecimalViewController alloc] initWithReport:currentReport andIndex:index+1];
			decVC.title = @"Decimal";
			[self.navigationController pushViewController:decVC animated:YES];
			[decVC release];
		}else if ([type isEqualToString:@"date"]) {
			DateViewController *dateVC = [[DateViewController alloc] initWithReport:currentReport andIndex:index+1];
			dateVC.title = @"Date";
			[self.navigationController pushViewController:dateVC animated:YES];
			[dateVC release];
		}else if ([type isEqualToString:@"dateTime"]) {
			DateTimeViewController *dateTimeVC = [[DateTimeViewController alloc] initWithReport:currentReport andIndex:index+1];
			dateTimeVC.title = @"Date and time";
			[self.navigationController pushViewController:dateTimeVC animated:YES];
			[dateTimeVC release];
		}else if ([type isEqualToString:@"select"]) {
			SelectViewController *selectVC = [[SelectViewController alloc] initWithReport:currentReport andIndex:index+1];
			selectVC.title = @"Select multiple";
			[self.navigationController pushViewController:selectVC animated:YES];
			[selectVC release];
		}else if ([type isEqualToString:@"select1"]) {
			Select1ViewController *select1VC = [[Select1ViewController alloc] initWithReport:currentReport andIndex:index+1];
			[self.navigationController pushViewController:select1VC animated:YES];
			select1VC.title = @"Select one";
			[select1VC release];
		}else if ([type isEqualToString:@"geopoint"]) {
			GPSViewController *gpsVC = [[GPSViewController alloc] initWithReport:currentReport andIndex:index+1];
			gpsVC.title = @"GPS";
			[self.navigationController pushViewController:gpsVC animated:YES];
			[gpsVC release];
		}else if ([type isEqualToString:@"imageType"]) {
			ImageViewController *imageVC = [[ImageViewController alloc] initWithReport:currentReport andIndex:index+1];
			imageVC.title = @"Image";
			[self.navigationController pushViewController:imageVC animated:YES];
			[imageVC release];
		}else if ([type isEqualToString:@"audioType"]) {
			AudioViewController *audioVC = [[AudioViewController alloc] initWithReport:currentReport andIndex:index+1];
			audioVC.title = @"Audio";
			[self.navigationController pushViewController:audioVC animated:YES];
			[audioVC release];
		}else if ([type isEqualToString:@"videoType"]) {
			VideoViewController *videoVC = [[VideoViewController alloc] initWithReport:currentReport andIndex:index+1];
			videoVC.title = @"Video";
			[self.navigationController pushViewController:videoVC animated:YES];
			[videoVC release];
		}else {
			UnknownObjectViewController *ukVC = [[UnknownObjectViewController alloc] initWithReport:currentReport andIndex:index+1];
			ukVC.title = @"Unknown Type";
			[self.navigationController pushViewController:ukVC animated:YES];
			[ukVC release];
		}
	}else if(self.validated){
		FormDoneViewController *formDoneVC = [[FormDoneViewController alloc] init];
		formDoneVC.currentReport = currentReport;
		formDoneVC.title = @"Done";
		[self.navigationController pushViewController:formDoneVC animated:YES];
		[formDoneVC release];
	}else{
        [self notValidatedAlert];
    }
}

-(void)backgroundClick{
	//[textField resignFirstResponder];
}

//-(id)initWithArray:(NSArray *)dataArray andIndex:(int)dataIndex andReport:(Report *)report{
-(id)initWithReport:(Report *)report andIndex:(int)dataIndex{
	if ([self init]) {
		//self.data = dataArray;
		index = dataIndex;
		self.currentReport = report;
        self.validated = YES;
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] init];
	
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
    
    if ([self.navigationController.viewControllers count] == 2) {
        self.navigationItem.backBarButtonItem = nil;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed)];
        self.navigationItem.leftBarButtonItem = backButton;
        [backButton release];
    }
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
	label.backgroundColor = [UIColor clearColor];
	
	hint = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 50)];
	hint.numberOfLines = 3;
	hint.font = [UIFont systemFontOfSize:12];
	hint.textColor = [UIColor darkGrayColor];
	hint.backgroundColor = [UIColor clearColor];
	
	UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
	bgButton.frame = CGRectMake(0, 0, 320, 367);
	[bgButton addTarget:self action:@selector(backgroundClick) forControlEvents:UIControlEventTouchUpInside];
	
	[view addSubview:label];
	[view addSubview:hint];
	
	[view addSubview:bgButton];
	
	self.view = view;
	[view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	/*NSDictionary *dataDic = [data objectAtIndex:index];
	label.text = [dataDic objectForKey:@"label"];
	hint.text = [dataDic objectForKey:@"hint"];*/
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	label.text = thisEntry.label;
	hint.text = thisEntry.hint;
	
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self addValue];
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
	//NSLog(@"dealloc %@", label.text);
	[label release];
	[hint release];
	
	[data release];
	
	[currentReport release];
	
    [super dealloc];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Leave report"]) {
		[self.navigationController popViewControllerAnimated:YES];
	}else {
        //NSLog(@"ignoring");
    }
}

@end

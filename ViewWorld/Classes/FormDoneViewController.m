    //
//  FormDoneViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/10/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "FormDoneViewController.h"
#import "ViewWorldAppDelegate.h"
#import "FlurryAPI.h"


@implementation FormDoneViewController

@synthesize currentReport;

-(NSString *)createTitle{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm:ss-dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *returnString = [NSString stringWithFormat:@"%@-%@", currentReport.origTitle, dateString];
    
    [dateFormatter release];
    return returnString;
}

-(void)saveAsUnfinished{
	
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	currentReport.finished = NO;
	if (currentReport.isNew) {
        currentReport.title = [self createTitle];
		currentReport.isNew = NO;
		[delegate.reports addObject:currentReport];
		[FlurryAPI logEvent:@"report_added_unfinished"];
		//NSLog(@"report added as unfinished");
	}else {
		[FlurryAPI logEvent:@"report_updated_unfinished"];
		//NSLog(@"report updated");
	}
	
	[delegate archiveReports];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)saveAsFinished{
	
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	currentReport.finished = YES;
	if (currentReport.isNew) {
        currentReport.title = [self createTitle];
		currentReport.isNew = NO;
		[delegate.reports addObject:currentReport];
		[FlurryAPI logEvent:@"report_added_finished"];
		//NSLog(@"report added as finished");
	}else {
		[FlurryAPI logEvent:@"report_updated_finished"];
		//NSLog(@"report updated");
	}
	
	[delegate archiveReports];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] init];
	
	view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textAlignment = UITextAlignmentCenter;
	headerLabel.text = NSLocalizedString(@"Form completed!", @"headerLabel"); 
	headerLabel.font = [UIFont systemFontOfSize:20];
	
	UIButton *unfinishedButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
	unfinishedButton.frame = CGRectMake(60, 100, 200, 44);
	[unfinishedButton addTarget:self action:@selector(saveAsUnfinished) forControlEvents:UIControlEventTouchUpInside];
	[unfinishedButton setTitle:NSLocalizedString(@"Save as unfinished", @"unfinishedButton_title") forState:UIControlStateNormal];
	
	UIButton *finishedButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
	finishedButton.frame = CGRectMake(60, 200, 200, 44);
	[finishedButton addTarget:self action:@selector(saveAsFinished) forControlEvents:UIControlEventTouchUpInside];
	[finishedButton setTitle:NSLocalizedString(@"Save as finished", @"finishedButton_title") forState:UIControlStateNormal];
	
	[view addSubview:headerLabel];
	[view addSubview:unfinishedButton];
	[view addSubview:finishedButton];
	
	[headerLabel release];
	
	self.view = view;
	[view release];
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
	[currentReport release];
    [super dealloc];
}


@end

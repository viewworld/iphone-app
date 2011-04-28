    //
//  ViewReportViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/3/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "ViewReportViewController.h"
#import "ViewWorldAppDelegate.h"
#import "FilledReportsViewController.h"


@implementation ViewReportViewController

-(void)viewUnfinishedReports{
	/*UnfinishedReportsViewController *unfinishedReportsVC = [[UnfinishedReportsViewController alloc] init];
	[self.navigationController pushViewController:unfinishedReportsVC animated:YES];
	[unfinishedReportsVC release];*/
	FilledReportsViewController *finishedReportsVC = [[FilledReportsViewController alloc] init];
	finishedReportsVC.isFinished = NO;
	finishedReportsVC.title = @"Unfinished reports";
	[self.navigationController pushViewController:finishedReportsVC animated:YES];
	[finishedReportsVC release];
}

-(void)viewFinishedReports{
	FilledReportsViewController *finishedReportsVC = [[FilledReportsViewController alloc] init];
	finishedReportsVC.isFinished = YES;
	finishedReportsVC.title = @"Finished reports";
	[self.navigationController pushViewController:finishedReportsVC animated:YES];
	[finishedReportsVC release];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	UILabel *reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
	reportLabel.backgroundColor = [UIColor clearColor];
	reportLabel.text = @"Reports:";
	
	UIButton *viewUnfinishedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	viewUnfinishedButton.frame = CGRectMake(10, 50, 200, 40);
	[viewUnfinishedButton addTarget:self action:@selector(viewUnfinishedReports) forControlEvents:UIControlEventTouchUpInside];
	[viewUnfinishedButton setTitle:@"View unfinished reports" forState:UIControlStateNormal];
	
	UIButton *viewFinishedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	viewFinishedButton.frame = CGRectMake(10, 100, 200, 40);
	[viewFinishedButton addTarget:self action:@selector(viewFinishedReports) forControlEvents:UIControlEventTouchUpInside];
	[viewFinishedButton setTitle:@"View finished reports" forState:UIControlStateNormal];
	
	[view addSubview:reportLabel];
	[view addSubview:viewUnfinishedButton];
	[view addSubview:viewFinishedButton];
	
	[reportLabel release];
	
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
    [super dealloc];
}


@end

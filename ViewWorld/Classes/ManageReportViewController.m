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

#import "ManageReportViewController.h"
#import "DownloadFormsViewController.h"
#import "FilledReportsViewController.h"
#import "UploadSelectionViewController.h"

@implementation ManageReportViewController

-(void)downloadButtonPressed{
	DownloadFormsViewController *downloadFormsVC = [[DownloadFormsViewController alloc] init];
	[self.navigationController pushViewController:downloadFormsVC animated:YES];
	[downloadFormsVC release];
}

-(void)viewUnfinishedReports{
	FilledReportsViewController *finishedReportsVC = [[FilledReportsViewController alloc] init];
	finishedReportsVC.isFinished = NO;
	[self.navigationController pushViewController:finishedReportsVC animated:YES];
	[finishedReportsVC release];
}

-(void)viewFinishedReports{
	FilledReportsViewController *finishedReportsVC = [[FilledReportsViewController alloc] init];
	finishedReportsVC.isFinished = YES;
	[self.navigationController pushViewController:finishedReportsVC animated:YES];
	[finishedReportsVC release];
}

-(void)uploadFinishedReports{
	UploadSelectionViewController *uploadSelectionVC = [[UploadSelectionViewController alloc] init];
	uploadSelectionVC.title = @"Select report";
	[self.navigationController pushViewController:uploadSelectionVC animated:YES];	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	UILabel *reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
	reportLabel.backgroundColor = [UIColor clearColor];
	reportLabel.text = @"Reports:";
	
	/*UIButton *viewUnfinishedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	viewUnfinishedButton.frame = CGRectMake(10, 50, 200, 40);
	[viewUnfinishedButton addTarget:self action:@selector(viewUnfinishedReports) forControlEvents:UIControlEventTouchUpInside];
	[viewUnfinishedButton setTitle:@"View unfinished reports" forState:UIControlStateNormal];
	
	UIButton *viewFinishedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	viewFinishedButton.frame = CGRectMake(10, 100, 200, 40);
	[viewFinishedButton addTarget:self action:@selector(viewFinishedReports) forControlEvents:UIControlEventTouchUpInside];
	[viewFinishedButton setTitle:@"View finished reports" forState:UIControlStateNormal];*/
	
	UIButton *uploadFinishedReportsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	uploadFinishedReportsButton.frame = CGRectMake(10, 50, 200, 40);
	[uploadFinishedReportsButton addTarget:self action:@selector(uploadFinishedReports) forControlEvents:UIControlEventTouchUpInside];
	[uploadFinishedReportsButton setTitle:@"Upload finished reports" forState:UIControlStateNormal];
	
	UILabel *formLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
	formLabel.backgroundColor = [UIColor clearColor];
	formLabel.text = @"Forms:";
	
	UIButton *downloadFormButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	downloadFormButton.frame = CGRectMake(10, 140, 200, 40);
	[downloadFormButton addTarget:self action:@selector(downloadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[downloadFormButton setTitle:@"Get forms" forState:UIControlStateNormal];
	
	[view addSubview:reportLabel];
	//[view addSubview:viewUnfinishedButton];
	//[view addSubview:viewFinishedButton];
	[view addSubview:uploadFinishedReportsButton];
	[view addSubview:formLabel];
	[view addSubview:downloadFormButton];
	
	[reportLabel release];
	[formLabel release];
	
	self.view = view;
	[view release];
	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
    [super dealloc];
}


@end

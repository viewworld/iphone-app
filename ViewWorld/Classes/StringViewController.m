    //
//  StringViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "StringViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation StringViewController

@synthesize textView;

-(void)backgroundClick{
	[textView resignFirstResponder];
}

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	thisEntry.entryString = textView.text;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 300, 140)];
	//textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [textView.layer setBorderWidth: 1.0];
    [textView.layer setCornerRadius:8.0f];
    [textView.layer setMasksToBounds:YES];
	[textView becomeFirstResponder];
	
	textView.text = [[currentReport.entries objectAtIndex:index] entryString];

	
	/*UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
	bgButton.frame = CGRectMake(0, 0, 320, 367);
	[bgButton addTarget:self action:@selector(backgroundClicked) forControlEvents:UIControlEventTouchUpInside];*/
	
	//[self.view addSubview:bgButton];
	[self.view addSubview:textView];
	
	
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
	[textView release];
	
    [super dealloc];
}


@end

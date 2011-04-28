    //
//  NumberViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "IntViewController.h"


@implementation IntViewController

@synthesize textField;

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	thisEntry.entryString = textField.text;
}

-(void)backgroundClick{
	[textField resignFirstResponder];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
	//textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.keyboardType = UIKeyboardTypeNumberPad;
	[textField becomeFirstResponder];
	
	textField.text = [[currentReport.entries objectAtIndex:index] entryString];
	
	[self.view addSubview:textField];
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
	[textField release];
	
    [super dealloc];
}


@end

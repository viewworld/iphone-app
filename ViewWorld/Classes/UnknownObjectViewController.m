    //
//  UnknownObjectViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/25/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "UnknownObjectViewController.h"


@implementation UnknownObjectViewController

@synthesize _textField;

-(void)backgroundClick{
	[_textField resignFirstResponder];
}

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	thisEntry.entryString = _textField.text;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
	_textField.borderStyle = UITextBorderStyleRoundedRect;
	_textField.delegate = self;
	//_textField.keyboardType = UIKeyboardTypeNumberPad;
	[_textField becomeFirstResponder];
	
	[self.view addSubview:_textField];
	
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
	[_textField release];
    [super dealloc];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
    return YES;
}

@end

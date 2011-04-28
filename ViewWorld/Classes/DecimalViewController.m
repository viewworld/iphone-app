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

#import "DecimalViewController.h"

@implementation DecimalViewController

@synthesize textField;

-(void)addValue{
    NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    Entry *thisEntry = [currentReport.entries objectAtIndex:index];
    
    if ([trimmedString length] > 0){
        NSError *error = NULL; //@"\\b^[0-9]+(.[0-9])+$\\b"
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(([1-9][0-9]*)|0)\\.\\d+$" options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger number = [regex numberOfMatchesInString:trimmedString options:0 range:NSMakeRange(0, [trimmedString length])];
        //NSLog(@"number: %d", number);
        if (number == 1) {
            validated = YES;
        }else {
            validated = NO;
        }
        
        /*
        NSArray *matches = [regex matchesInString:trimmedString options:0 range:NSMakeRange(0, [trimmedString length])];
        for (NSTextCheckingResult *match in matches) {
            NSLog(@"substring: %@", [trimmedString substringWithRange:[match range]]);
        }*/
    }else{
        validated = YES;
    }
    
    textField.text = trimmedString;
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
	textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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

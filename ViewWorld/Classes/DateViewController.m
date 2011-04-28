    //
//  DateViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "DateViewController.h"


@implementation DateViewController

@synthesize datePicker;

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	thisEntry.dateSet = YES;
	thisEntry.date = datePicker.date;
}

-(void)dateChanged{
	//NSLog(@"date changed");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 151, 0, 0)];
	datePicker.date = [NSDate date];
	datePicker.datePickerMode = UIDatePickerModeDate;
	[datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
	
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	if (thisEntry.dateSet) {
		//NSLog(@"date already exists");
		datePicker.date = thisEntry.date;
	}
	
	[self.view addSubview:datePicker];
	
    [super viewDidLoad];
}

- (void)dealloc {
	[datePicker release];
    [super dealloc];
}


@end

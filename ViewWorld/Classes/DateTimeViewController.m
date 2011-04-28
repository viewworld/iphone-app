    //
//  DateTimeViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 2/3/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "DateTimeViewController.h"


@implementation DateTimeViewController

@synthesize datePicker;

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	thisEntry.dateTimeSet = YES;
	thisEntry.dateTime = datePicker.date;
}

-(void)dateChanged{
	//NSLog(@"date changed");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 151, 0, 0)];
	datePicker.date = [NSDate date];
	datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	[datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
	
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	if (thisEntry.dateTimeSet) {
		//NSLog(@"datetime already exists");
		datePicker.date = thisEntry.dateTime;
	}
	
	[self.view addSubview:datePicker];
	
    [super viewDidLoad];
}

- (void)dealloc {
	[datePicker release];
    [super dealloc];
}

@end

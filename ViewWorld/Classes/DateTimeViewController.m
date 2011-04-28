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

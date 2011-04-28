//
//  BaseEntryViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Report.h"


@interface BaseEntryViewController : UIViewController <UIAlertViewDelegate>{
	UILabel *label;
	UILabel *hint;
	
	int index;
	
	NSArray *data;
	
	Report *currentReport;
    
    BOOL validated;
}
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UILabel *hint;

@property(nonatomic, retain) NSArray *data;

@property(nonatomic, retain) Report *currentReport;

@property(nonatomic, assign) BOOL validated;

//-(id)initWithArray:(NSArray *)dataArray andIndex:(int)dataIndex andReport:(Report *)report;
-(id)initWithReport:(Report *)report andIndex:(int)dataIndex;

@end

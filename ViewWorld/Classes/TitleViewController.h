//
//  TitleViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/26/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TitleViewController : UIViewController <UITextFieldDelegate>{
	UITextField *titleTextField;
	
	int index;
	
	NSArray *data;
	
	Report *currentReport;
}
@property(nonatomic, retain) UITextField *titleTextField;

@property(nonatomic, retain) NSArray *data;

@property(nonatomic, retain) Report *currentReport;

//-(id)initWithArray:(NSArray *)dataArray andIndex:(int)dataIndex andReport:(Report *)report;
-(id)initWithReport:(Report *)report andIndex:(int)dataIndex;

@end

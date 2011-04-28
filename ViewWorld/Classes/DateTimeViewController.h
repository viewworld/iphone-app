//
//  DateTimeViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 2/3/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseEntryViewController.h"


@interface DateTimeViewController : BaseEntryViewController {
	UIDatePicker *datePicker;
}
@property(nonatomic, retain) UIDatePicker *datePicker;

@end

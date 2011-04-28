//
//  StringViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseEntryViewController.h"


@interface StringViewController : BaseEntryViewController {
	
	UITextView *textView;
}

@property(nonatomic, retain) UITextView *textView;

@end

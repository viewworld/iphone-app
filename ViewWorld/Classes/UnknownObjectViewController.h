//
//  UnknownObjectViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/25/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UnknownObjectViewController : BaseEntryViewController <UITextFieldDelegate>{
	UITextField *_textField;
}
@property(nonatomic, retain) UITextField *_textField;

@end

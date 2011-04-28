//
//  SetupViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/3/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetupViewController : UIViewController <UITextFieldDelegate>{
	UITextField *usernameField;
	UITextField *passwordField;
	
	UITextField *uploadUrlField;
	UITextField *formlistUrlField;
	
	UISwitch *facebookSwitch;
	UISwitch *twitterSwitch;
}
@property(nonatomic, retain) UITextField *usernameField;
@property(nonatomic, retain) UITextField *passwordField;

@property(nonatomic, retain) UITextField *uploadUrlField;
@property(nonatomic, retain) UITextField *formlistUrlField;

@property(nonatomic, retain) UISwitch *facebookSwitch;
@property(nonatomic, retain) UISwitch *twitterSwitch;

@end

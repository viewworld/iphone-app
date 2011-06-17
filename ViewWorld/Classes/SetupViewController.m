    //
//  SetupViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/3/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "SetupViewController.h"


@implementation SetupViewController

@synthesize usernameField, passwordField;

@synthesize uploadUrlField, formlistUrlField;

@synthesize facebookSwitch, twitterSwitch;

-(void)socialMediaSwitchChanged:(id)sender{
	UISwitch *currentSwitch = (UISwitch *)sender;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if ([currentSwitch isEqual:facebookSwitch]) {
		[userDefaults setBool:currentSwitch.on forKey:kFacebookKey];
	}else if([currentSwitch isEqual:twitterSwitch]){
		[userDefaults setBool:currentSwitch.on forKey:kTwitterKey];
	}
	[userDefaults synchronize];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
	usernameLabel.backgroundColor = [UIColor clearColor];
	usernameLabel.text = @"Username:";
	
	usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, 200, 30)];
	usernameField.borderStyle = UITextBorderStyleRoundedRect;
	usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	usernameField.placeholder = @"Username";
	usernameField.text = [userDefaults objectForKey:kUsernameKey];
	usernameField.delegate = self;
	usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
	
	UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 300, 20)];
	passwordLabel.backgroundColor = [UIColor clearColor];
	passwordLabel.text = @"Password:";
	
	passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 200, 30)];
	passwordField.borderStyle = UITextBorderStyleRoundedRect;
	passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	passwordField.placeholder = @"Password";
	passwordField.text = [userDefaults objectForKey:kPasswordKey];
	passwordField.secureTextEntry = YES;
	passwordField.delegate = self;
	passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	
	facebookSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 160, 94, 27)];
	[facebookSwitch addTarget:self action:@selector(socialMediaSwitchChanged:) forControlEvents:UIControlEventValueChanged];
	facebookSwitch.on = [userDefaults boolForKey:kFacebookKey];
	
	UILabel *facebookLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 160, 196, 27)];
	facebookLabel.backgroundColor = [UIColor clearColor];
	facebookLabel.text = @"Facebook";
	
	twitterSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 202, 94, 27)];
	[twitterSwitch addTarget:self action:@selector(socialMediaSwitchChanged:) forControlEvents:UIControlEventValueChanged];
	twitterSwitch.on = [userDefaults boolForKey:kTwitterKey];
	
	UILabel *twitterLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 202, 196, 27)];
	twitterLabel.backgroundColor = [UIColor clearColor];
	twitterLabel.text = @"Twitter";
	
	[view addSubview:usernameLabel];
	[view addSubview:usernameField];
	[view addSubview:passwordLabel];
	[view addSubview:passwordField];
	
	/*[view addSubview:facebookSwitch];
	[view addSubview:facebookLabel];
	[view addSubview:twitterSwitch];
	[view addSubview:twitterLabel];*/
	
	[facebookLabel release];
	[twitterLabel release];
	
	[usernameLabel release];
	[passwordLabel release];
	
	
	//Temp url fields
	UILabel *formlistLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 300, 20)];
	formlistLabel.backgroundColor = [UIColor clearColor];
	formlistLabel.text = @"Formlist URL (DEBUG):";
	
	UILabel *uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 300, 20)];
	uploadLabel.backgroundColor = [UIColor clearColor];
	uploadLabel.text = @"Upload URL (DEBUG):";
	
	formlistUrlField = [[UITextField alloc] initWithFrame:CGRectMake(10, 180, 300, 30)];
	formlistUrlField.borderStyle = UITextBorderStyleRoundedRect;
	formlistUrlField.font = [UIFont systemFontOfSize:13];
	formlistUrlField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	formlistUrlField.text = [userDefaults objectForKey:kFormlistUrlKey];
	formlistUrlField.delegate = self;
	formlistUrlField.autocorrectionType = UITextAutocorrectionTypeNo;
	
	uploadUrlField = [[UITextField alloc] initWithFrame:CGRectMake(10, 250, 300, 30)];
	uploadUrlField.borderStyle = UITextBorderStyleRoundedRect;
	uploadUrlField.font = [UIFont systemFontOfSize:13];
	uploadUrlField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	uploadUrlField.text = [userDefaults objectForKey:kUploadUrlKey];
	uploadUrlField.delegate = self;
	uploadUrlField.autocorrectionType = UITextAutocorrectionTypeNo;
	
#ifdef DEBUG
    [view addSubview:formlistLabel];
	[view addSubview:formlistUrlField];
	[view addSubview:uploadLabel];
	[view addSubview:uploadUrlField];
#endif
    
	[formlistLabel release];
	[uploadLabel release];
	
	self.view = view;
	[view release];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[uploadUrlField release];
	[formlistUrlField release];
	[usernameField release];
	[passwordField release];
	[facebookSwitch release];
	[twitterSwitch release];
    [super dealloc];
}

#pragma mark TextField Delegate Methods

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	return YES;
}*/

/*- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
	[self selectColorButtonPressed];
}*/


//- (void)textFieldDidEndEditing:(UITextField *)textField{
/*
 CGRect viewFrame = self.frame;
 viewFrame.origin.y += animatedDistance;
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
 
 [self setFrame:viewFrame];
 
 [UIView commitAnimations];
 */
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:usernameField.text forKey:kUsernameKey];
	[userDefaults setObject:passwordField.text forKey:kPasswordKey];
	[userDefaults setObject:uploadUrlField.text forKey:kUploadUrlKey];
	[userDefaults setObject:formlistUrlField.text forKey:kFormlistUrlKey];
	[userDefaults synchronize];
	[textField resignFirstResponder];
    return YES;
}

@end

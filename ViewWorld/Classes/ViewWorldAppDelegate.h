//
//  ViewWorldAppDelegate.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 12/22/10.
//  Copyright 2010 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageReportViewController.h"
#import "ViewReportViewController.h"
#import "SetupViewController.h"
#import "InfoViewController.h"
#import "SelectFormViewController.h"
#import "CrashReportSender.h"

@interface ViewWorldAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CrashReportSenderDelegate> {
    NSOperationQueue *queue;
	
    UIWindow *window;
	
	UITabBarController *tabBarController;
	//NewReportViewController *newReportViewController;
	SelectFormViewController *selectFormViewController;
	ManageReportViewController *manageReportViewController;
	ViewReportViewController *viewReportViewController;
	SetupViewController *setupViewController;
	InfoViewController *infoViewController;
	
	NSString *dataFilePath;
	NSMutableArray *reports;
	
	NSMutableArray *formListArray;
	
	UIViewController *nextViewController;
}
@property(nonatomic, retain) UIViewController *nextViewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) UITabBarController *tabBarController;
//@property(nonatomic, retain) NewReportViewController *newReportViewController;
@property(nonatomic, retain) SelectFormViewController *selectFormViewController;
@property(nonatomic, retain) ManageReportViewController *manageReportViewController;
@property(nonatomic, retain) ViewReportViewController *viewReportViewController;
@property(nonatomic, retain) SetupViewController *setupViewController;
@property(nonatomic, retain) InfoViewController *infoViewController;

@property(nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic, retain) NSMutableArray *reports;
@property (nonatomic, retain) NSString *dataFilePath;

@property(nonatomic, retain) NSMutableArray *formListArray;

- (NSURL *)applicationDocumentsDirectory;

-(NSString *)formListFilePath;
-(NSString *)filePathForFormWithTitle:(NSString *)titleString;
-(void)archiveReports;

@end


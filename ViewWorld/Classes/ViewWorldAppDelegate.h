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


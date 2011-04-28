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

#import "ViewWorldAppDelegate.h"
#import "Report.h"

@implementation ViewWorldAppDelegate

@synthesize nextViewController;
@synthesize window;
@synthesize tabBarController;
@synthesize selectFormViewController;
@synthesize manageReportViewController;
@synthesize viewReportViewController;
@synthesize setupViewController;
@synthesize infoViewController;

@synthesize queue;

@synthesize formListArray;

@synthesize reports;
@synthesize dataFilePath;

-(void)archiveReports{
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:reports forKey:@"reports"];
	[encoder finishEncoding];
	
	[theData writeToFile:dataFilePath atomically:YES];
	[encoder release];
}

-(NSString *)filePathForFormWithTitle:(NSString *)titleString{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat", titleString]];
}

-(NSString *)formListFilePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFormListFilePath];
}

-(id)init{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"reports.dat"];
	self.dataFilePath = path;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:dataFilePath]) {
		//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:dataFilePath];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"reports"];
		self.reports = tempArray;
		[decoder finishDecoding];
		[decoder release];		
	} else {
		//NSLog(@"no file found. creating empty array");
		reports = [[NSMutableArray alloc] init];
	}
	
	//NSLog(@"saved reports count %d", [reports count]);
	/*for(Report *rep in reports){
		NSLog(@"rep title: %@", rep.title);
	}*/
	
	//Load saved form list
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithContentsOfFile:[self formListFilePath]];
	self.formListArray = tempArray;
	//NSLog(@"form list count %d", [formListArray count]);
	[tempArray release];
	
	return self;
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	
    [[CrashReportSender sharedCrashReportSender] sendCrashReportToURL:CRASH_REPORTER_URL 
                                                             delegate:self 
                                                     activateFeedback:NO];
    
    
	queue = [[NSOperationQueue alloc] init];
	
    // Override point for customization after application launch.
	tabBarController = [[UITabBarController alloc] init];
	
	//newReportViewController = [[NewReportViewController alloc] init];
	//newReportViewController.title = @"New Report"
	selectFormViewController = [[SelectFormViewController alloc] init];
	selectFormViewController.title = @"New Report";
	UINavigationController *newReportNavController = [[UINavigationController alloc] initWithRootViewController:selectFormViewController];
	newReportNavController.tabBarItem.title = @"New";
	newReportNavController.tabBarItem.image = [UIImage imageNamed:@"new_icon.png"];
	
	manageReportViewController = [[ManageReportViewController alloc] init];
	manageReportViewController.title = @"Manage Reports";
	UINavigationController *manageReportNavController = [[UINavigationController alloc] initWithRootViewController:manageReportViewController];
	manageReportNavController.tabBarItem.title = @"Manage";
	manageReportNavController.tabBarItem.image = [UIImage imageNamed:@"manage_icon.png"];
    
	viewReportViewController = [[ViewReportViewController alloc] init];
	viewReportViewController.title = @"View Report";
	UINavigationController *viewReportNavController = [[UINavigationController alloc] initWithRootViewController:viewReportViewController];
	viewReportNavController.tabBarItem.title = @"View";
	viewReportNavController.tabBarItem.image = [UIImage imageNamed:@"view_icon"];
	
	setupViewController = [[SetupViewController alloc] init];
	setupViewController.title = @"Setup";
	UINavigationController *setupNavController = [[UINavigationController alloc] initWithRootViewController:setupViewController];
	setupNavController.tabBarItem.title = @"Setup";
	setupNavController.tabBarItem.image = [UIImage imageNamed:@"setup_icon.png"];
	
	infoViewController = [[InfoViewController alloc] init];
	infoViewController.title = @"Info";
	UINavigationController *infoNavController = [[UINavigationController alloc] initWithRootViewController:infoViewController];
	infoNavController.tabBarItem.title = @"Info";
	infoNavController.tabBarItem.image = [UIImage imageNamed:@"info_icon.png"];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:infoNavController, newReportNavController, viewReportNavController, manageReportNavController,setupNavController, nil];
	tabBarController.delegate = self;
	[newReportNavController release];
	[manageReportNavController release];
	[viewReportNavController release];
	[setupNavController release];
	[infoNavController release];
	
	[window addSubview:tabBarController.view];
	
	//Set upload and formlist url
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults objectForKey:kUploadUrlKey] == nil) {
		[userDefaults setObject:kUploadUrl forKey:kUploadUrlKey];
	}
	if ([userDefaults objectForKey:kFormlistUrlKey] == nil) {
		[userDefaults setObject:kServerUrl forKey:kFormlistUrlKey];
	}
	if ([userDefaults objectForKey:kUsernameKey] == nil) {
		[userDefaults setObject:@"demo" forKey:kUsernameKey];
	}
	if ([userDefaults objectForKey:kPasswordKey] == nil) {
		[userDefaults setObject:@"demo" forKey:kPasswordKey];
	}
	[userDefaults synchronize];
	
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	
	[self archiveReports];
	
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{	
	[selectFormViewController.navigationController popToRootViewControllerAnimated:NO];
	[manageReportViewController.navigationController popToRootViewControllerAnimated:NO];
	[setupViewController.navigationController popToRootViewControllerAnimated:NO];
	[viewReportViewController.navigationController popToRootViewControllerAnimated:NO];
	[infoViewController.navigationController popToRootViewControllerAnimated:NO];
}

- (BOOL)tabBarController:(UITabBarController *)tempTabBarController shouldSelectViewController:(UIViewController *)viewController{
	if (tabBarController.selectedIndex == 1) {
		if (![[selectFormViewController.navigationController topViewController] isKindOfClass:[SelectFormViewController class]]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Leaving this tab while entering a new report will discard the data you have entered. Are you sure you wish to leave this tab?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
			[alert show];
			[alert release];
			nextViewController = viewController;
			return NO;
		}else {
			[selectFormViewController._tableView setEditing:NO];
		}

	}
	
	return YES;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Continue"]) {
		//download forms alert
		tabBarController.selectedViewController = nextViewController;
		
	}
	nextViewController = nil;
}

- (void)dealloc {
	[nextViewController release];
    [queue release];
	
	[tabBarController release];
	//[newReportViewController release];
	[selectFormViewController release];
	[manageReportViewController release];
	[viewReportViewController release];
	[setupViewController release];
	[infoViewController release];;
    
	[formListArray release];
	
	[reports release];
	[dataFilePath release];
	
    [window release];
    [super dealloc];
}


@end


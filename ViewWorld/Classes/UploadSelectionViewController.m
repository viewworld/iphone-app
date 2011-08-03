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

#import "UploadSelectionViewController.h"
#import "ViewWorldAppDelegate.h"

#define kEncoding NSUTF8StringEncoding

//NSString *const kBoundaryString = @"4_ofOVbH8B6IvgSLDYc5eRB8NOPeG0pXjpp5e";

typedef enum {
    alertViewTypeInvalidUP = 1,
    alertViewTypeSucces
}alertViewType;

@implementation UploadSelectionViewController

@synthesize _tableView;
@synthesize reportsArray;
@synthesize lastSelectedReport;
@synthesize uploadArray;

-(void)uploadSelectedReports{
	if ([uploadArray count] > 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		ReportUploader *reportUploader = nil;
		for(Report *thisReport in uploadArray){
			//NSLog(@"uploading %@", thisReport.title);
			reportUploader = [[ReportUploader alloc] initWithReport:thisReport];
			reportUploader.delegate = self;
			//[reportUploader release];
		}
		[reportUploader release];
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No selection", @"uploadSelectionViewController_alert_title")
                                                        message:NSLocalizedString(@"You have not selected any reports for upload.", @"uploadSelectionViewController_alert_message") 
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"uploadSelectionViewController_alert_ok") 
                                              otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

}

-(void)deleteReport{
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[reportsArray removeObject:lastSelectedReport];
	[delegate.reports removeObject:lastSelectedReport];
	[delegate archiveReports];
	[_tableView reloadData];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)loadView {
	UIView *view = [[UIView alloc] init];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[view addSubview:_tableView];
	
	self.view = view;
	[view release];
	
}

-(void)viewWillAppear:(BOOL)animated{
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == %@", [NSNumber numberWithBool:YES]];
	self.reportsArray = [[delegate.reports filteredArrayUsingPredicate:predicate] mutableCopy];
	
	[_tableView reloadData];
	
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    failedUploads = [[NSMutableString alloc] init];
	
	uploadArray = [[NSMutableArray alloc] init];
	numUploaded = 0;
	
    [super viewDidLoad];
}

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
    [failedUploads release];
	[uploadArray release];
	[lastSelectedReport release];
	[reportsArray release];
	[_tableView release];
    [super dealloc];
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [reportsArray count];	
}

-(UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	NSUInteger row = [indexPath row];
	
	UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil){
		CGRect cellFrame = CGRectZero;//CGRectMake(0, 0, 320, 70);
		cell = [[[UITableViewCell alloc] initWithFrame:cellFrame reuseIdentifier:nil] autorelease];
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	Report *report = [reportsArray objectAtIndex:row];
	
	cell.textLabel.text = report.title;
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return NSLocalizedString(@"Choose report to upload", @"uploadSelectionViewController_section_header_choose_report_to_upload");
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 100.0;
}

#pragma mark Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	if ([reportsArray count] == 0) {
		return nil;
	}else {
		UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
		UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		uploadButton.frame = CGRectMake(10, 20, 300, 44);
		[uploadButton addTarget:self action:@selector(uploadSelectedReports) forControlEvents:UIControlEventTouchUpInside];
		[uploadButton setTitle:NSLocalizedString(@"Upload selected reports", @"uploadButton_title") forState:UIControlStateNormal];
		[view addSubview:uploadButton];
		
		return view;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	Report *thisReport = [reportsArray objectAtIndex:row];
	
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[uploadArray addObject:thisReport];
	}else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		[uploadArray removeObject:thisReport];
	}
	//NSLog(@"num uploads %d", [uploadArray count]);
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	//NSLog(@"response");
	//NSLog(@"mime: %@", [response MIMEType]);
	int statuscode = 0;
	if ([response respondsToSelector:@selector(statusCode)])	{
		statuscode = [((NSHTTPURLResponse *)response) statusCode];
		
	}
	NSLog(@"statuscode: %d", statuscode);
	
	if(statuscode == 201){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Report uploaded!", @"uploadSelectionViewController_alert_title") 
                                                        message:NSLocalizedString(@"The report was successfully uploaded to the server.", @"uploadSelectionViewController_alert_meesage") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"uploadSelectionViewController_alert_ok") 
                                              otherButtonTitles:nil];
        [alert setTag:alertViewTypeSucces];
		[alert show];
		[alert release];
		
		[self deleteReport];
	}else {
		UIAlertView *alertFail = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload failed!", @"uploadSelectionViewController_alert_title") 
                                                            message:NSLocalizedString(@"The report could not be uploaded to the server. Try again later.", @"uploadSelectionViewController_alert_message") 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", @"uploadSelectionViewController_alert_ok") 
                                                  otherButtonTitles:nil];
		[alertFail show];
		[alertFail release];
	}

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	//NSLog(@"length %d", [data length]);
	[testData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	
	NSLog(@"data length %d", [testData length]);
	NSString *newString = [[NSString alloc] initWithData:testData encoding:kEncoding];
	NSLog(@"%@", newString);
	[newString release];
	[testData release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{   
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"Report could not be uploaded %@", [error description]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	NSLog(@"challenge");
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if([challenge previousFailureCount] > 3 || [userDefaults objectForKey:kUsernameKey] == nil){
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Username/Password", @"uploadSelectionViewController_alert_title") 
                                                        message:NSLocalizedString(@"The server could not validate your username or password. Please check your information in the \"Setup\" tab.", @"uploadSelectionViewController_alert_message") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"uploadSelectionViewController_alert_ok") 
                                              otherButtonTitles:nil];
        [alert setTag:alertViewTypeInvalidUP];
		[alert show];
		[alert release];
	}
	NSURLCredential *credential = [NSURLCredential credentialWithUser:[userDefaults objectForKey:kUsernameKey] password:[userDefaults objectForKey:kPasswordKey] persistence:NSURLCredentialPersistenceNone];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == alertViewTypeSucces) {
        //NSLog(@"uploaded successfully");
    }
    else if([alertView tag] == alertViewTypeInvalidUP){
		//incorrect username/password alert
		self.navigationController.tabBarController.selectedIndex = 3;
		[self.navigationController popViewControllerAnimated:NO];
	}
}

#pragma mark ReportUploaderDelegate

-(void)reportUploaded:(Report *)report statuscode:(int)code{
	
	if (code == 201) {
		ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[reportsArray removeObject:report];
		[delegate.reports removeObject:report];
		[delegate archiveReports];
		numUploaded += 1;
	}else{
		/*UIAlertView *alertFail = [[UIAlertView alloc] initWithTitle:@"Upload failed!" message:[NSString stringWithFormat:@"The report '%@' could not be uploaded to the server. Try again later.", report.title] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertFail show];
		[alertFail release];*/
        
        [failedUploads appendFormat:@"%@\n", report.title];
        
		[uploadArray removeObject:report];
	}
	
	if(numUploaded == [uploadArray count]){
		NSMutableString *string = [[NSMutableString alloc] init];
		for(Report *rep in uploadArray){
			[string appendFormat:@"%@\n", rep.title];
		}
		if ([uploadArray count] > 0) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reports uploaded!", @"uploadSelectionViewController_alert_title") 
                                                            message:[NSString stringWithFormat:NSLocalizedString(@"The report(s):\n %@ was successfully uploaded to the server.", @"uploadSelectionViewController_alert_message"), string] 
                                                           delegate:nil 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", @"uploadSelectionViewController_alert_ok") 
                                                  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else{
            UIAlertView *alertFail = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uploads failed!", @"uploadSelectionViewController_alert_title") 
                                                                message:[NSString stringWithFormat:NSLocalizedString(@"The report(s):\n %@ could not be uploaded to the server. Try again later.", @"uploadSelectionViewController_alert_message"), failedUploads] 
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"Ok", @"uploadSelectionViewController_alert_ok") 
                                                      otherButtonTitles:nil];
            [alertFail show];
            [alertFail release];
        }
        failedUploads = nil;
        [failedUploads release];
        failedUploads = [[NSMutableString alloc] init];
        
		[string release];
		numUploaded = 0;
		uploadArray = nil;
        [uploadArray release];
        uploadArray = [[NSMutableArray alloc] init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[_tableView reloadData];
	}	
}

@end

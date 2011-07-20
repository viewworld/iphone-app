    //
//  DownloadFormsViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/24/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "DownloadFormsViewController.h"
#import "FormListParser.h"
#import "ViewWorldAppDelegate.h"
#import "MBBase64.h"
#import "FlurryAPI.h"

typedef enum {
    alertViewTypeInvalidUP = 1,
    alertViewTypeWarning
}alertViewType;

@implementation DownloadFormsViewController

@synthesize downloadedFormList;
@synthesize _tableView;
@synthesize formListData;
@synthesize downloadArray;

-(void)downloadFormsByAdding{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[delegate.formListArray addObjectsFromArray:downloadArray];
	[delegate.formListArray writeToFile:[delegate formListFilePath] atomically:YES];
	
	//Save the forms as nsdata objects with the title as filename
	FormDownloader *formDownloader = nil;
	for(NSDictionary *dic in downloadArray){
		//[formDownloader release];
		formDownloader = [[FormDownloader alloc] initWithFormDic:dic];
		formDownloader.delegate = self;
	}
	[formDownloader release];
	//[self.navigationController popViewControllerAnimated:YES];
}

-(void)downloadFormsAndWipeExisting{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	//Delete existing reports
	//delegate.reports = nil;
	//[delegate.reports release];
	//delegate.reports = [[NSMutableArray alloc] init];
	[delegate.reports removeAllObjects];
	[delegate archiveReports];
	
	//Delete existing forms
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filePath = nil;
	NSError *error = nil;
	for(NSDictionary *dic in delegate.formListArray){
		filePath = [delegate filePathForFormWithTitle:[dic objectForKey:@"title"]];
		if([fileManager fileExistsAtPath:filePath]) {
			//NSLog(@"removing form: %@", [dic objectForKey:@"title"]);
			[fileManager removeItemAtPath:filePath error:&error];
		}
	}
	
	delegate.formListArray = downloadArray;//downloadedFormList;
	[delegate.formListArray writeToFile:[delegate formListFilePath] atomically:YES];
	
	
	//Save the forms as nsdata objects with the title as filename
	FormDownloader *formDownloader = nil;
	for(NSDictionary *dic in delegate.formListArray){
		formDownloader = [[FormDownloader alloc] initWithFormDic:dic];
		formDownloader.delegate = self;
	}
	[formDownloader release];

	//[self.navigationController popViewControllerAnimated:YES];
}

-(void)downloadFormsAlert{
	[FlurryAPI logEvent:@"downloading_new_forms"];
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if([delegate.formListArray count] > 0){
		BOOL formExists = NO;
		for(NSDictionary *dic in downloadArray){
			if ([delegate.formListArray containsObject:dic]) {
				formExists = YES;
			}
		}
		
		if (formExists) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning!", @"downloadFormsViewController_alert_title") 
                                                            message:NSLocalizedString(@"You already have one of the selected forms downloaded to your device. Redownloading existing forms will replace it and delete all unsend reports. Are you sure you want to download the new forms?", @"downloadFormsViewController_alert_message") 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"downloadFormsViewController_alert_cancel") 
                                                  otherButtonTitles:NSLocalizedString(@"Continue", @"downloadFormsViewController_alert_continue"), nil];
            [alert setTag:alertViewTypeWarning];
			[alert show];
			[alert release];
		}else {
			if ([downloadArray count] > 0) {
				[self downloadFormsByAdding];
			}else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No selection", @"downloadFormsViewController_alert_title") 
                                                                message:NSLocalizedString(@"You have not selected any forms for download.", @"downloadFormsViewController_alert_title") 
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"Ok", @"downloadFormsViewController_alert_ok") 
                                                      otherButtonTitles:nil];
				[alert show];
				[alert release];
			}

		}

	}else {
		[self downloadFormsAndWipeExisting];
	}

}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] init];
	
	self.title = NSLocalizedString(@"Download forms", @"downloadFormsViewController_title");
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[view addSubview:_tableView];
	
	self.view = view;
	[view release];
}

-(void)viewWillDisappear:(BOOL)animated{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[super viewWillDisappear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	numDownloaded = 0;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	downloadArray = [[NSMutableArray alloc] init];
	
	formListData = [[NSMutableData alloc] init];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSURL *url = [NSURL URLWithString:[userDefaults objectForKey:kFormlistUrlKey]];
	NSLog(@"Formlist url: %@", [userDefaults objectForKey:kFormlistUrlKey]);
	//NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	NSString *authString = [NSString stringWithFormat:@"%@:%@", [userDefaults objectForKey:kUsernameKey], [userDefaults objectForKey:kPasswordKey]];
	NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
	NSString *auth = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
	[request setValue:auth forHTTPHeaderField:@"Authorization"];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[connection release];
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
	[downloadArray release];
	[formListData release];
	[_tableView release];
	[downloadedFormList release];
    [super dealloc];
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [formListData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//NSLog(@"%d", [formListData length]);
	NSString *string = [[NSString alloc] initWithData:formListData encoding:NSUTF8StringEncoding];
	//NSLog(@"%@", string);
	[string release];
	FormListParser *parser = [[FormListParser alloc] init];
	NSArray *parsedForms = [parser parseForm:formListData];
	//NSLog(@"count %d", [parsedForms count]);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	self.downloadedFormList = parsedForms;
	[_tableView reloadData];
	
	//[connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{   
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"Form list data could not be fetched %@", [error description]);
	
	//[connection release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	int statuscode = 0;
	if ([response respondsToSelector:@selector(statusCode)])	{
		statuscode = [((NSHTTPURLResponse *)response) statusCode];
		
	}
	//NSLog(@"statuscode: %d", statuscode);
	
	if(statuscode == 500){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Username/Password", @"downloadFormsViewController_alert_title") 
                                                        message:NSLocalizedString(@"The server could not validate your username or password. Please check your information in the \"Setup\" tab.", @"downloadFormsViewController_alert_message") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Ok" ,@"downloadFormsViewController_alert_ok") 
                                              otherButtonTitles:nil];
        [alert setTag:alertViewTypeInvalidUP];
		[alert show];
		[alert release];
	}
	
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	//NSLog(@"challenge");
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if([challenge previousFailureCount] > 3 || [userDefaults objectForKey:kUsernameKey] == nil){
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Username/Password" ,@"downloadFormsViewController_alert_title") 
                                                        message:NSLocalizedString(@"The server could not validate your username or password. Please check your information in the \"Setup\" tab." ,@"downloadFormsViewController_alert_message") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Ok" ,@"downloadFormsViewController_alert_ok") 
                                              otherButtonTitles:nil];
        [alert setTag:alertViewTypeInvalidUP];
		[alert show];
		[alert release];
	}
	NSURLCredential *credential = [NSURLCredential credentialWithUser:[userDefaults objectForKey:kUsernameKey] password:[userDefaults objectForKey:kPasswordKey] persistence:NSURLCredentialPersistenceNone];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [downloadedFormList count];	
}

-(UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	NSUInteger row = [indexPath row];
	
	UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil){
		CGRect cellFrame = CGRectZero;//CGRectMake(0, 0, 320, 70);
		cell = [[[UITableViewCell alloc] initWithFrame:cellFrame reuseIdentifier:SimpleTableIdentifier] autorelease];
		
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	NSDictionary *form = [downloadedFormList objectAtIndex:row];
	
	cell.textLabel.text = [form objectForKey:@"title"];
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return NSLocalizedString(@"Available forms on server", @"downloadFormsViewController_section_header_available_forms_on_server");
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 100.0;
}

#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	NSDictionary *thisDic = [downloadedFormList objectAtIndex:row];
	
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[downloadArray addObject:thisDic];
	}else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		[downloadArray removeObject:thisDic];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	if ([downloadedFormList count] == 0) {
		return nil;
	}else {
		UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
		UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		downloadButton.frame = CGRectMake(10, 20, 300, 44);
		[downloadButton addTarget:self action:@selector(downloadFormsAlert) forControlEvents:UIControlEventTouchUpInside];
		[downloadButton setTitle:NSLocalizedString(@"Download selected forms", @"downloadFormsViewController_downloadButton_title") forState:UIControlStateNormal];
		[view addSubview:downloadButton];
		
		return view;
	}
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == alertViewTypeWarning && [alertView cancelButtonIndex] != buttonIndex) {
		//download forms alert
		[self downloadFormsAndWipeExisting];
    }
    else if ([alertView tag] == alertViewTypeInvalidUP && [alertView cancelButtonIndex] == buttonIndex) {
        //incorrect username/password alert
		self.navigationController.tabBarController.selectedIndex = 4;
		[self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark FormDownloaderDelegate

-(void)formDownloaded{
	numDownloaded += 1;
	if(numDownloaded == [downloadArray count]){
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		numDownloaded = 0;
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

@end

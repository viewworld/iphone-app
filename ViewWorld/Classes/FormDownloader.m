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

#import "FormDownloader.h"
#import "ViewWorldAppDelegate.h"
#import "MBBase64.h"


@implementation FormDownloader

@synthesize formData;
@synthesize formDictionary;
@synthesize delegate;

-(id)initWithFormDic:(NSDictionary *)formDic{
	if([self init]){
		//NSLog(@"her3");
		self.formDictionary = formDic;
		formData = [[NSMutableData alloc] init];
		//NSLog(@"downloading form from: %@", [formDictionary objectForKey:@"url"]);
		NSURL *url = [NSURL URLWithString:[formDictionary objectForKey:@"url"]];
		//NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSString *authString = [NSString stringWithFormat:@"%@:%@", [userDefaults objectForKey:kUsernameKey], [userDefaults objectForKey:kPasswordKey]];
		NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
		NSString *auth = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
		[request setValue:auth forHTTPHeaderField:@"Authorization"];
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[connection release];
	}
	
	return self;
}
 
-(void)dealloc{
	[formData release];
	[formDictionary release];
	[super dealloc];
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
	
	if(statuscode == 500){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Username/Password", @"formDownloader_alert_title")
                                                        message:NSLocalizedString(@"The server could not validate your username or password. Please check your information in the \"Setup\" tab.", @"formDownloader_alert_message") 
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"formDownloader_alert_ok") 
                                              otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
   [formData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//NSLog(@"%d", [formData length]);
	
	ViewWorldAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	if([formData writeToFile:[appDelegate filePathForFormWithTitle:[formDictionary objectForKey:@"title"]] atomically:YES]){
		//NSLog(@"data saved");
	}else {
		//NSLog(@"data NOT saved");
	}
	
	if ([delegate respondsToSelector:@selector(formDownloaded)]) {
		[delegate formDownloaded];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{   
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"Form data could not be downloaded %@", [error description]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	//NSLog(@"challenge");
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if([challenge previousFailureCount] > 3 || [userDefaults objectForKey:kUsernameKey] == nil){
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Username/Password", @"formDownloader_alert_title") 
                                                        message:NSLocalizedString(@"The server could not validate your username or password. Please check your information in the \"Setup\" tab.", @"formDownloader_alert_message") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"formDownloader_alert_ok") 
                                              otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	NSURLCredential *credential = [NSURLCredential credentialWithUser:[userDefaults objectForKey:kUsernameKey] password:[userDefaults objectForKey:kPasswordKey] persistence:NSURLCredentialPersistenceNone];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

@end

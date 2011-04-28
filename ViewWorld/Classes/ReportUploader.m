//
//  FormUploader.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 2/18/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "ReportUploader.h"
#import "MBBase64.h"

#define kEncoding NSUTF8StringEncoding

NSString *const kBoundaryString = @"4_ofOVbH8B6IvgSLDYc5eRB8NOPeG0pXjpp5e";

@implementation ReportUploader

@synthesize currentReport, delegate;

-(NSData *)createXmlString:(Report *)report{
	NSMutableString *xmlString = [[NSMutableString alloc] init];
	[xmlString appendString:@"<?xml version='1.0' ?>"];
	[xmlString appendString:[NSString stringWithFormat:@"<data id=\"%@\">", report.dataId]];
    
    //Append device id and starttime
    if ([report.bindDic objectForKey:@"deviceid"] != nil) {
        //NSLog(@"deviceID");
        NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
        [xmlString appendString:[NSString stringWithFormat:@"<deviceid>%@</deviceid>>", udid]];
    }
    if ([report.bindDic objectForKey:@"start"] != nil) {
        //NSLog(@"START");
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
        [xmlString appendString:[NSString stringWithFormat:@"<start>%@</start>", [dateFormatter stringFromDate:report.startTime]]];
        [dateFormatter release];
        //NSLog(@"%@", xmlString);
    }
	
	NSMutableData *imageString = [[NSMutableData alloc] init];
    NSMutableData *videoData = [[NSMutableData alloc] init];
    NSMutableData *audioData = [[NSMutableData alloc] init];
	
	for(Entry *entry in report.entries){
		if ([entry.entryString length] > 0) {
			//NSLog(@"entrystring");
			[xmlString appendString:[NSString stringWithFormat:@"<%@>%@</%@>", entry.type, entry.entryString, entry.type]];
		}else if([entry.imageData length] > 0) {
			//NSLog(@"image");
			NSString *imageFileName = [NSString stringWithFormat:@"%d%d%d%d%d%d%d%d%d%d%d%d%d.jpg", (arc4random()% 9)+1, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10];
			//NSLog(@"%@", imageFileName);
			[xmlString appendString:[NSString stringWithFormat:@"<%@>%@</%@>", entry.type, imageFileName, entry.type]];
			[imageString appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kBoundaryString] dataUsingEncoding:kEncoding]];
			[imageString appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", imageFileName, imageFileName] dataUsingEncoding:kEncoding]];
			[imageString appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:kEncoding]];
			[imageString appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:kEncoding]];
			[imageString appendData:entry.imageData];
		}else if(entry.horAcc > 0){
			//NSLog(@"location");
			[xmlString appendString:[NSString stringWithFormat:@"<%@>%f %f %f %f</%@>",entry.type, entry.lat, entry.lng, entry.horAcc, entry.verAcc, entry.type]];
		}else if (entry.dateSet) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"yyyy-MM-dd"];
			[xmlString appendString:[NSString stringWithFormat:@"<%@>%@</%@>", entry.type, [formatter stringFromDate:entry.date], entry.type]];
			[formatter release];
		}else if (entry.dateTimeSet) {
			NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
			[timeFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
			[xmlString appendString:[NSString stringWithFormat:@"<%@>%@</%@>", entry.type, [timeFormatter stringFromDate:entry.dateTime], entry.type]];
			[timeFormatter release];
		}else if([entry.itemEntries count] > 0){
			//NSLog(@"item entries");
			NSMutableString *valueString = [[NSMutableString alloc] init];
			for(NSString *value in entry.itemEntries){
				if ([valueString length] > 0) {
					[valueString appendString:@" "];
				}
				[valueString appendString:[NSString stringWithFormat:@"%@", value]];
			}
			[xmlString appendString:[NSString stringWithFormat:@"<%@>%@</%@>", entry.type, valueString, entry.type]];
			[valueString release];
		}else if([entry.videoData length] > 0){
			//NSLog(@"video");
			NSString *videoFileName = [NSString stringWithFormat:@"%d%d%d%d%d%d%d%d%d%d%d%d%d.mov", (arc4random()% 9)+1, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10];
			//NSLog(@"%@", imageFileName);
			[xmlString appendString:[NSString stringWithFormat:@"<%@>%@</%@>", entry.type, videoFileName, entry.type]];
			[videoData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kBoundaryString] dataUsingEncoding:kEncoding]];
			[videoData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", videoFileName, videoFileName] dataUsingEncoding:kEncoding]];
			[videoData appendData:[@"Content-Type: video/mov\r\n" dataUsingEncoding:kEncoding]];
			[videoData appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:kEncoding]];
			[videoData appendData:entry.videoData];
		}else if([entry.audioData length] > 0){
			//NSLog(@"audio");
			NSString *audioFileName = [NSString stringWithFormat:@"%d%d%d%d%d%d%d%d%d%d%d%d%d.caf", (arc4random()% 9)+1, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10, arc4random() %10];
			//NSLog(@"%@", imageFileName);
			[xmlString appendString:[NSString stringWithFormat:@"<%@>%@</%@>", entry.type, audioFileName, entry.type]];
			[audioData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kBoundaryString] dataUsingEncoding:kEncoding]];
			[audioData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", audioFileName, audioFileName] dataUsingEncoding:kEncoding]];
			[audioData appendData:[@"Content-Type: audio/caf\r\n" dataUsingEncoding:kEncoding]];
			[audioData appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:kEncoding]];
			[audioData appendData:entry.audioData];
		}else {
			//NSLog(@"empty entry");
			[xmlString appendString:[NSString stringWithFormat:@"<%@></%@>", entry.type, entry.type]];
		}
		
	}
	
	[xmlString appendString:@"</data>"];
	//NSLog(@"STRING: %@", xmlString);
	
	NSMutableData *returnData = [[NSMutableData alloc] init];
	[returnData appendData:[xmlString dataUsingEncoding:kEncoding]];
	//NSLog(@"LENGTH %d", [returnData length]);
	//NSLog(@"image data length %d", [imageString length]);
	if ([imageString length] > 0) {
		[returnData appendData:imageString];
	}
    if ([videoData length] > 0) {
		[returnData appendData:videoData];
	}
    if ([audioData length] > 0) {
		[returnData appendData:audioData];
	}
	//NSLog(@"LENGTH final %d", [returnData length]);
	
	[imageString release];
    [videoData release];
    [audioData release];
	[xmlString release];
	
	return returnData;
}

-(id)initWithReport:(Report *)aReport{
	if([self init]){
		self.currentReport = aReport;
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSURL *url = [NSURL URLWithString:[userDefaults objectForKey:kUploadUrlKey]];
		NSLog(@"Upload url: %@", [userDefaults objectForKey:kUploadUrlKey]);
		NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
		
		NSString *authString = [NSString stringWithFormat:@"%@:%@", [userDefaults objectForKey:kUsernameKey], [userDefaults objectForKey:kPasswordKey]];
		NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
		NSString *auth = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
		[req setValue:auth forHTTPHeaderField:@"Authorization"];
		
		[req setHTTPMethod:@"POST"];
		
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundaryString];
		[req setValue:contentType forHTTPHeaderField:@"Content-Type"];
		[req setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
		
		//[req setValue:contentType forHTTPHeaderField:@"Host"];
		
		NSData *xmlString = [self createXmlString:self.currentReport];
		
		//NSLog(@"Return length %d", [xmlString length]);
		
		//adding the body:
		NSMutableData *postBody = [NSMutableData data];
		[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundaryString] dataUsingEncoding:kEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"xml_submission_file\"; filename=\"%@.xml\"\r\n", self.currentReport.title] dataUsingEncoding:kEncoding]];
		[postBody appendData:[@"Content-Type: text/xml\r\n" dataUsingEncoding:kEncoding]];
		[postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:kEncoding]];
		[postBody appendData:xmlString];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kBoundaryString] dataUsingEncoding:kEncoding]];

		[req setHTTPBody:postBody];
		
		/*NSString *test = [[NSString alloc] initWithData:postBody encoding:kEncoding];
		NSLog(@"%@", test);
		[test release];*/

		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
		[connection release];
	}
	
	return self;
}

-(void)dealloc{
	[currentReport release];
	[super dealloc];
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	int statuscode = 0;
	if ([response respondsToSelector:@selector(statusCode)])	{
		statuscode = [((NSHTTPURLResponse *)response) statusCode];
		
	}
	NSLog(@"statuscode: %d", statuscode);

	if([delegate respondsToSelector:@selector(reportUploaded:statuscode:)]){
		[delegate reportUploaded:self.currentReport statuscode:statuscode];
	}
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{   
	NSLog(@"Report could not be uploaded %@", [error description]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	//NSLog(@"challenge");
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if([challenge previousFailureCount] > 3 || [userDefaults objectForKey:kUsernameKey] == nil){
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username/Password" message:@"The server could not validate your username or password. Please check your information in the \"Setup\" tab." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	NSURLCredential *credential = [NSURLCredential credentialWithUser:[userDefaults objectForKey:kUsernameKey] password:[userDefaults objectForKey:kPasswordKey] persistence:NSURLCredentialPersistenceNone];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

@end

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

#import "InfoViewController.h"
#import "Reachability.h"


@implementation InfoViewController

@synthesize backButton, forwardButton, webView;
@synthesize internetActive, hostActive, pageHasBeenLoaded;

-(void)reloadPage{
    [webView reload];
}

-(void)back{
	[webView goBack];
}

-(void)forward{
	[webView goForward];
}

- (void) checkNetworkStatus:(NSNotification *)notice{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:{
            //NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:{
            //NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:{
            //NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
        
            break;
            
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus){
        case NotReachable:{
            //NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:{
            //NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:{
            //NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
            
        }
    }
    
    if(self.internetActive){
        if (!self.pageHasBeenLoaded) {
            //NSLog(@"loading page");
            NSURL *url = [NSURL URLWithString:kInfoUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
        }else{
            //NSLog(@"page was previously loaded");
        }
    }else{
        if (!self.pageHasBeenLoaded) {
            //NSLog(@"default");
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"default" ofType:@"html"]isDirectory:NO]]];
        }else  {
            //NSLog(@"no internet but page has previously been loaded");
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    //NSLog(@"disappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
   // NSLog(@"appear");
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
    
    [super viewWillAppear:animated];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	webView.scalesPageToFit = TRUE;
	webView.delegate = self;
	[view addSubview:webView];
	
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 323, 320, 44)];
	backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	backButton.enabled = NO;
	forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
	forwardButton.enabled = NO;
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadPage)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *fixedSpace20 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedSpace20.width = 25.0;
	toolBar.items = [NSArray arrayWithObjects:backButton, fixedSpace20, forwardButton, flexibleSpace, reloadButton, fixedSpace20, nil];
	[fixedSpace20 release];
    [flexibleSpace release];
    [reloadButton release];
	[view addSubview:toolBar];
	[toolBar release];
	
	self.view = view;
	[view release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	/*NSURL *url = [NSURL URLWithString:kInfoUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];*/
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
    self.pageHasBeenLoaded = NO;

}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.pageHasBeenLoaded = NO;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [internetReachable release];
    [hostReachable release];
	[backButton release];
	[forwardButton release];
	[webView release];

    [super dealloc];
}

#pragma mark UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	//NSLog(@"An error happened during load: %@", error);
    self.pageHasBeenLoaded = NO;

}
- (void)webViewDidStartLoad:(UIWebView *)webView{
	//NSLog(@"loading started");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webViewTemp{
	//NSLog(@"finished loading");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if ([webView canGoBack]) {
		backButton.enabled = YES;
	}else {
		backButton.enabled = NO;
	}
	
	if ([webView canGoForward]) {
		forwardButton.enabled = YES;
	}else {
		forwardButton.enabled = NO;
	}
    self.pageHasBeenLoaded = YES;
}


@end

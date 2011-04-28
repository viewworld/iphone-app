//
//  InfoViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/3/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface InfoViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *webView;
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    
    BOOL internetActive;
    BOOL hostActive;
    
    BOOL pageHasBeenLoaded;
}
@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) UIBarButtonItem *backButton;
@property(nonatomic, retain) UIBarButtonItem *forwardButton;

@property(nonatomic, assign) BOOL internetActive;
@property(nonatomic, assign) BOOL hostActive;

@property(nonatomic, assign) BOOL pageHasBeenLoaded;

- (void) checkNetworkStatus:(NSNotification *)notice;

@end

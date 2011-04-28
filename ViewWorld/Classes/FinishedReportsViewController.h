//
//  FinishedReportsViewController.h
//  ViewWorld
//
//  Created by Daniel Kold on 1/25/11.
//  Copyright 2011 Ncouraged. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FinishedReportsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *_tableView;
	
	NSMutableArray *reportsArray;
	
	BOOL isFinished;
}
@property(nonatomic, retain) UITableView *_tableView;
@property(nonatomic, retain) NSMutableArray *reportsArray;
@property(nonatomic, assign) BOOL isFinished;

@end

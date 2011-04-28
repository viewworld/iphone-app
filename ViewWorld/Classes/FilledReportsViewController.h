//
//  FinishedReportsViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/25/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FilledReportsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *_tableView;
	
	NSMutableArray *reportsArray;
	
	BOOL isFinished;
}
@property(nonatomic, retain) UITableView *_tableView;
@property(nonatomic, retain) NSMutableArray *reportsArray;
@property(nonatomic, assign) BOOL isFinished;

@end

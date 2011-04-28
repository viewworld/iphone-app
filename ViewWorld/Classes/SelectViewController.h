//
//  SelectViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseEntryViewController.h"

@interface SelectViewController : BaseEntryViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *_tableView;
	
	NSArray *tableViewItems;
	
	NSMutableArray *selectionArray;
}
@property(nonatomic, retain) UITableView *_tableView;
@property(nonatomic, retain) NSArray *tableViewItems;
@property(nonatomic, retain) NSMutableArray *selectionArray;

@end

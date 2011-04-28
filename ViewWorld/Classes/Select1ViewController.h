//
//  Select1ViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseEntryViewController.h"

@interface Select1ViewController : BaseEntryViewController <UITableViewDelegate, UITableViewDataSource>{
	UITableView *_tableView;
	
	NSArray *items;
	
	NSString *lastSelectedValue;
	
	UITableViewCell *startSelectedCell;
}
@property(nonatomic, retain) UITableView *_tableView;
@property(nonatomic, retain) NSArray *items;
@property(nonatomic, retain) NSString *lastSelectedValue;
@property(nonatomic, retain) UITableViewCell *startSelectedCell;


@end

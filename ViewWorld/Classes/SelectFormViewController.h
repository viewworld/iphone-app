//
//  SelectFormViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/4/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectFormViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *_tableView;
	
	NSArray *forms;
	UILabel *noFormsLabel;
	
	UITableViewCell *lastSelected;
	
	NSString *parsedTitle;
}
@property(nonatomic, retain) UITableView *_tableView;
@property(nonatomic, retain) NSArray *forms;
@property(nonatomic, retain) UITableViewCell *lastSelected;
@property(nonatomic, retain) UILabel *noFormsLabel;

@property(nonatomic, retain) NSString *parsedTitle;

-(void)doneParsing:(Report *)parsedReport;

@end

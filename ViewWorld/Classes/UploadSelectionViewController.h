//
//  UploadSelectionViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/31/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportUploader.h"

@interface UploadSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ReportUploaderDelegate>{
	UITableView *_tableView;
	
	NSMutableArray *reportsArray;
	
	NSMutableData *testData;
	
	NSMutableArray *uploadArray;
	
	Report *lastSelectedReport;
	
	int numUploaded;
    
    NSMutableString *failedUploads;
}
@property(nonatomic, retain) UITableView *_tableView;
@property(nonatomic, retain) NSMutableArray *reportsArray;
@property(nonatomic, retain) Report *lastSelectedReport;
@property(nonatomic, retain) NSMutableArray *uploadArray;

@end

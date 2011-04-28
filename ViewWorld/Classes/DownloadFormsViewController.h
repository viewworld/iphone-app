//
//  DownloadFormsViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/24/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDownloader.h"


@interface DownloadFormsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, FormDownloaderDelegate>{
	UITableView *_tableView;
	NSArray *downloadedFormList;
	
	NSMutableArray *downloadArray;
	
	NSMutableData *formListData;
	
	int numDownloaded;
}
@property(nonatomic, retain) UITableView *_tableView;
@property(nonatomic, retain) NSArray *downloadedFormList;
@property(nonatomic, retain) NSMutableData *formListData;
@property(nonatomic, retain) NSMutableArray *downloadArray;

@end

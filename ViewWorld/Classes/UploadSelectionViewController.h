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

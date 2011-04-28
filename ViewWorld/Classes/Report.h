//
//  Report.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/14/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Report : NSObject {
	NSMutableArray *entires;
    
    //The form title used for generating the displayed title
    NSString *origTitle;
    
	NSString *title;
	NSString *dataId;
	BOOL finished;
	BOOL isNew;
	
	NSDictionary *bindDic;
    
    NSDate *startTime;
}
@property(nonatomic, retain) NSMutableArray *entries;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *origTitle;
@property(nonatomic, retain) NSString *dataId;
@property(nonatomic, assign) BOOL finished;
@property(nonatomic, assign) BOOL isNew;

@property(nonatomic, retain) NSDictionary *bindDic;
@property(nonatomic, retain) NSDate *startTime;

@end

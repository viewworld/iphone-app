//
//  Entry.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/28/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Entry : NSObject <NSCopying>{
	NSDictionary *dataDic;
	
	//Parsed stuff
	NSString *type;
	NSString *label;
	NSString *hint;
	NSArray *items;
	
	//For all text field/view entries
	NSString *entryString;
	//For gps entries
	CLLocation *location;
	CGFloat lat;
	CGFloat lng;
	CGFloat horAcc;
	CGFloat verAcc;
	
	//For image entries
	NSData *imageData;
    //For audio entries
    NSData *audioData;
    //For video entries
    NSData *videoData;
	//For select (several)
	NSArray *itemEntries;
	//For dates
	NSDate *date;
	BOOL dateSet;
	
	NSDate *dateTime;
	BOOL dateTimeSet;
	
}
@property(nonatomic, retain) NSDictionary *dataDic;

@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) NSString *hint;
@property(nonatomic, retain) NSArray *items;

@property(nonatomic, retain) NSString *entryString;
@property(nonatomic, retain) CLLocation *location;
@property(nonatomic, assign) CGFloat lat;
@property(nonatomic, assign) CGFloat lng;
@property(nonatomic, assign) CGFloat horAcc;
@property(nonatomic, assign) CGFloat verAcc;

@property(nonatomic, retain) NSData *imageData;
@property(nonatomic, retain) NSData *audioData;
@property(nonatomic, retain) NSData *videoData;
@property(nonatomic, retain) NSArray *itemEntries;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, assign) BOOL dateSet;
@property(nonatomic, retain) NSDate *dateTime;
@property(nonatomic, assign) BOOL dateTimeSet;

-(id) copyWithZone: (NSZone *) zone;

@end

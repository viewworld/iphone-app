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

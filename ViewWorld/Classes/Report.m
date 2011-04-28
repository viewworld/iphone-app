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

#import "Report.h"


@implementation Report

@synthesize entries, finished, title, origTitle, isNew, dataId;
@synthesize bindDic;
@synthesize startTime;

-(id)init{
	if([super init]){
		entries= [[NSMutableArray alloc] init];
		title = [[NSString alloc] init];
        origTitle = [[NSString alloc] init];
		dataId = [[NSString alloc] init];
		finished = NO;
		isNew = YES;
		
		bindDic = [[NSDictionary alloc] init];
        startTime = [[NSDate date] retain];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)coder{
	self.entries = [coder decodeObjectForKey:@"entries"];
	self.finished = [coder decodeBoolForKey:@"finished"];
	self.isNew = [coder decodeBoolForKey:@"isNew"];
	self.title = [coder decodeObjectForKey:@"title"];
    self.origTitle = [coder decodeObjectForKey:@"origTitle"];
	self.dataId = [coder decodeObjectForKey:@"dataId"];
	self.bindDic = [coder decodeObjectForKey:@"bindDic"];
    self.startTime = [coder decodeObjectForKey:@"startTime"];
	return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:entries forKey:@"entries"];
	[encoder encodeBool:finished forKey:@"finished"];
	[encoder encodeBool:isNew forKey:@"isNew"];
	[encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:origTitle forKey:@"origTitle"];
	[encoder encodeObject:dataId forKey:@"dataId"];
	[encoder encodeObject:bindDic forKey:@"bindDic"];
    [encoder encodeObject:startTime forKey:@"startTime"];
}

-(void)dealloc{
	[dataId release];
	[entries release];
	[title release];
    [origTitle release];
    [bindDic release];
    [startTime release];
	[super dealloc];
}

@end

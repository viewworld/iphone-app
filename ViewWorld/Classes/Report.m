//
//  Report.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/14/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

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

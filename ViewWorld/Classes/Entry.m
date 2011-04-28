//
//  Entry.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/28/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "Entry.h"


@implementation Entry

@synthesize dataDic;
@synthesize type, label, hint, items;
@synthesize entryString;
@synthesize imageData;
@synthesize audioData;
@synthesize videoData;
@synthesize itemEntries;
@synthesize location;
@synthesize date;
@synthesize lat, lng, horAcc, verAcc;
@synthesize dateSet;
@synthesize dateTime, dateTimeSet;

-(id) copyWithZone: (NSZone *) zone{
	Entry *entryCopy = [[Entry allocWithZone:zone] init];
	
	entryCopy.dataDic = dataDic;
	entryCopy.type = type;
	entryCopy.entryString = entryString;
	entryCopy.imageData = imageData;
    entryCopy.audioData = audioData;
    entryCopy.videoData = videoData;
	entryCopy.itemEntries = itemEntries;
	entryCopy.items = items;
	entryCopy.location = location;
	entryCopy.date = date;
	entryCopy.label = label;
	entryCopy.hint = hint;
	entryCopy.lat = lat;
	entryCopy.lng = lng;
	entryCopy.horAcc = horAcc;
	entryCopy.verAcc = verAcc;
	entryCopy.dateSet = dateSet;
	entryCopy.dateTime = dateTime;
	entryCopy.dateTimeSet = dateTimeSet;
	
	return entryCopy;
}

-(id)init{
	if([super init]){
		dataDic = [[NSMutableDictionary alloc] init];
		type = [[NSString alloc] init];
		entryString = [[NSString alloc] init];
		imageData = [[NSData alloc] init];
        audioData = [[NSData alloc] init];
        videoData = [[NSData alloc] init];
		itemEntries = [[NSArray alloc] init];
		location = [[CLLocation alloc] init];
		date = [[NSDate alloc] init];
		lat = 0.0;
		lng = 0.0;
		horAcc = 0.0;
		verAcc = 0.0;
		dateSet = NO;
		dateTime = [[NSDate alloc] init];
		dateTimeSet = NO;
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)coder{
	self.dataDic = [coder decodeObjectForKey:@"dataDic"];
	self.type = [coder decodeObjectForKey:@"type"];
	self.label = [coder decodeObjectForKey:@"label"];
	self.hint = [coder decodeObjectForKey:@"hint"];
	self.items = [coder decodeObjectForKey:@"items"];
	self.entryString = [coder decodeObjectForKey:@"entryString"];
	self.imageData = [coder decodeObjectForKey:@"imageData"];
    self.audioData = [coder decodeObjectForKey:@"audioData"];
    self.videoData = [coder decodeObjectForKey:@"videoData"];
	self.itemEntries = [coder decodeObjectForKey:@"itemEntries"];
	self.location = [coder decodeObjectForKey:@"location"];
	self.date = [coder decodeObjectForKey:@"date"];
	self.dateSet = [coder decodeBoolForKey:@"dateSet"];
	self.dateTime = [coder decodeObjectForKey:@"dateTime"];
	self.dateTimeSet = [coder decodeBoolForKey:@"dateTimeSet"];
	
	self.lat = [coder decodeFloatForKey:@"lat"];
	self.lng = [coder decodeFloatForKey:@"lng"];
	self.horAcc = [coder decodeFloatForKey:@"horAcc"];
	self.verAcc = [coder decodeFloatForKey:@"verAcc"];
	return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:dataDic forKey:@"dataDic"];
	[encoder encodeObject:type forKey:@"type"];
	[encoder encodeObject:label forKey:@"label"];
	[encoder encodeObject:hint forKey:@"hint"];
	[encoder encodeObject:items forKey:@"items"];
	[encoder encodeObject:entryString forKey:@"entryString"];
	[encoder encodeObject:imageData forKey:@"imageData"];
    [encoder encodeObject:audioData forKey:@"audioData"];
    [encoder encodeObject:videoData forKey:@"videoData"];
	[encoder encodeObject:itemEntries forKey:@"itemEntries"];
	[encoder encodeObject:location forKey:@"location"];
	[encoder encodeObject:date forKey:@"date"];
	[encoder encodeBool:dateSet forKey:@"dateSet"];
	[encoder encodeObject:dateTime forKey:@"dateTime"];
	[encoder encodeBool:dateTimeSet forKey:@"dateTimeSet"];
	
	[encoder encodeFloat:lat forKey:@"lat"];
	[encoder encodeFloat:lng forKey:@"lng"];
	[encoder encodeFloat:horAcc forKey:@"horAcc"];
	[encoder encodeFloat:verAcc forKey:@"verAcc"];
}

-(void)dealloc{
	[type release];
	[label release];
	[hint release];
	[items release];
	[entryString release];
	[imageData release];
    [audioData release];
    [videoData release];
	[itemEntries release];
	[location release];
	[dataDic release];
	[date release];
	[dateTime release];
	[super dealloc];
}

@end

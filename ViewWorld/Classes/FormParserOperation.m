//
//  FormParserOperation.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/5/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "FormParserOperation.h"
#import "FormParser.h"


@implementation FormParserOperation

@synthesize formData;

-(void)main{
	FormParser *parser = [[FormParser alloc] init];
	[parser parseForm:formData];
	[parser release];
}

-(void)dealloc{
	[formData release];
	[super dealloc];
}

@end

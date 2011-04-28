//
//  FormListParser.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/24/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FormListParser : NSObject <NSXMLParserDelegate>{
	NSMutableArray *formItems;
	NSMutableDictionary *item;
	
	NSString *currentElement;
	
	NSMutableString *currentTitle, *currentUrl;
	
}
@property(nonatomic, retain) NSMutableArray *formItems;
@property(nonatomic, retain) NSString *currentElement;

-(NSArray *)parseForm:(NSData *)data;

@end

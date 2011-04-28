//
//  FormParser.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/5/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FormParser : NSObject <NSXMLParserDelegate> {
	Report *newReport;
	Entry *entryItem;
	NSMutableArray *formItems;
	NSMutableDictionary *item;
	
	NSString *currentElement;
	
	NSMutableString *currentType, *currentLabel, *currentHint;
	
	//Title
	NSMutableString *currentTitle;
	
	//Data id
	NSString *dataId;
	
	//Selection specific
	NSMutableArray *currentSelectionItems;
	NSMutableString *currentItemLabel, *currentItemValue;
	
	BOOL insideBody;
	BOOL insideItem;
	BOOL insideHead;
	
	//Text ids
	NSMutableString *idKey, *idValue;	
	NSMutableDictionary *textIdDic;
	
	//Binds
	NSMutableDictionary *bindDic;
	
}
@property(nonatomic, retain) Report *newReport;
@property(nonatomic, retain) NSMutableArray *formItems;
@property(nonatomic, retain) NSString *currentElement;
@property(nonatomic, retain) NSMutableDictionary *textIdDic;
@property(nonatomic, retain) NSMutableDictionary *bindDic;

-(void)parseForm:(NSData *)data;

@end

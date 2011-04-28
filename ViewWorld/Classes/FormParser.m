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

#import "FormParser.h"
#import "ViewWorldAppDelegate.h"
#import "SelectFormViewController.h"

@implementation FormParser

@synthesize formItems;
@synthesize currentElement;
@synthesize textIdDic;
@synthesize bindDic;
@synthesize newReport;

-(void)parseForm:(NSData *)data{
	insideBody = NO;
	insideItem = NO;
	insideHead = NO;
	formItems = [[NSMutableArray alloc] init];
	textIdDic = [[NSMutableDictionary alloc] init];
	bindDic = [[NSMutableDictionary alloc] init];
	
	newReport = [[Report alloc] init];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{	
	//NSLog(@"found file and started parsing");	
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"parse error: %@", parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    //NSLog(@"found this element: %@", elementName);
	self.currentElement = elementName;
	
	//Parse xform title
	if([elementName isEqualToString:@"h:title"]){
		[currentTitle release];
		currentTitle = [[NSMutableString alloc] init];
	}else if([elementName isEqualToString:@"data"]){
		[dataId release];
		dataId = [[attributeDict objectForKey:@"id"] retain];
	}
	
	//Parse xform header
	if ([elementName isEqualToString:@"h:head"]) {
		insideHead = YES;
	}else if(insideHead && [elementName isEqualToString:@"text"]){
		[idKey release];
		[idValue release];
		
		idKey = [[attributeDict objectForKey:@"id"] retain];
		idValue = [[NSMutableString alloc] init];
    //Fill bindDic
	}else if (insideHead && [elementName isEqualToString:@"bind"]){
		NSString *nodeSet = [attributeDict objectForKey:@"nodeset"];
		//NSLog(@"nodeset before: %@", nodeSet);
		NSArray *nodeSetArray = [nodeSet componentsSeparatedByString:@"/"];
		if ([nodeSetArray count] > 0) {
			nodeSet = [nodeSetArray objectAtIndex:([nodeSetArray count]-1)];
		}		
		//NSLog(@"nodeset after: %@", nodeSet);
		NSString *type = [attributeDict objectForKey:@"type"];
		if (![attributeDict objectForKey:@"type"]) {
			type = @"unknown";
		}
		//NSLog(@"Key: %@ Value: %@", nodeSet, type);
		[bindDic setObject:type forKey:nodeSet];
        
        //Check for start and deviceid
        if([attributeDict objectForKey:@"jr:preloadParams"] != nil && [attributeDict objectForKey:@"jr:preload"] != nil){
            //NSLog(@"%@", [attributeDict objectForKey:@"jr:preloadParams"]);
            if ([[attributeDict objectForKey:@"jr:preloadParams"] isEqualToString:@"start"]) {
                [bindDic setObject:@"start" forKey:@"start"];
            }else if ([[attributeDict objectForKey:@"jr:preloadParams"] isEqualToString:@"deviceid"]) {
                [bindDic setObject:@"deviceid" forKey:@"deviceid"];
            }            
        }
	}
	
	//Parse xform body
	if ([elementName isEqualToString:@"h:body"]) {
		insideBody = YES;
	}else if (insideBody && ([elementName isEqualToString:@"input"] || [elementName isEqualToString:@"select"] || [elementName isEqualToString:@"select1"] || [elementName isEqualToString:@"upload"])) {
		
		[currentLabel release];
		[currentHint release];
		[item release];
		[entryItem release];
		
		//Selection
		[currentSelectionItems release];
		currentSelectionItems = [[NSMutableArray alloc] init];
		
		//Generic - all
		[currentType release];
		currentType = [[attributeDict objectForKey:@"ref"] retain];
		NSArray *typeArray = [currentType componentsSeparatedByString:@"/"];
		if ([typeArray count] > 0) {
			currentType = [[typeArray objectAtIndex:([typeArray count]-1)] retain];
		}
        
        if([attributeDict objectForKey:@"mediatype"] != nil){
            NSString *binaryType = [attributeDict objectForKey:@"mediatype"];
            NSRange range = [binaryType rangeOfString: @"audio"];
            if (range.location != NSNotFound) {
               // NSLog(@"I found audio.");
                [bindDic setObject:@"audioType" forKey:[NSString stringWithFormat:@"%@binary", currentType]];
                //currentType = [@"audioType" mutableCopy];
            }
            range = [binaryType rangeOfString: @"image"];
            if (range.location != NSNotFound) {
                //NSLog(@"I found image.");
                [bindDic setObject:@"imageType" forKey:[NSString stringWithFormat:@"%@binary", currentType]];
                //currentType = [@"imageType" mutableCopy];
            }
            range = [binaryType rangeOfString: @"video"];
            if (range.location != NSNotFound) {
               // NSLog(@"I found video.");
                [bindDic setObject:@"videoType" forKey:[NSString stringWithFormat:@"%@binary", currentType]];
                //currentType = [@"videoType" mutableCopy];
            }
        }
        //NSLog(@"%@", currentType);
		
		currentLabel = [[NSMutableString alloc] init];
		currentHint = [[NSMutableString alloc] init];
		item = [[NSMutableDictionary alloc] init];
		entryItem = [[Entry alloc] init];
		
	}else if(insideBody && [elementName isEqualToString:@"item"]){
		//Selection
		[currentItemLabel release];
		[currentItemValue release];
		
		currentItemLabel = [[NSMutableString alloc] init];
		currentItemValue = [[NSMutableString alloc] init];
		insideItem = YES;
	}
	
	//Fillout label and hint if there is a reference to the header
	if (insideBody && !insideItem && [elementName isEqualToString:@"label"] && [[attributeDict allKeys] count] > 0) {
		NSString *key = [attributeDict objectForKey:@"ref"];
		//NSLog(@"before %@", key);
		key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		//TODO: kan gøres pænere?
		key = [key stringByReplacingOccurrencesOfString:@"jr:itext('" withString:@""];
		key = [key stringByReplacingOccurrencesOfString:@"')" withString:@""];
		//NSLog(@"after %@", key);
		NSString *thisLabel = [textIdDic objectForKey:key];
		thisLabel = [thisLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if (thisLabel != nil) {
			[currentLabel release];
			currentLabel = [thisLabel mutableCopy];
		}
		//NSLog(@"%@", currentLabel);
	}else if (insideBody && !insideItem && [elementName isEqualToString:@"hint"] && [[attributeDict allKeys] count] > 0) {
		NSString *keyHint = [attributeDict objectForKey:@"ref"];
		//NSLog(@"before %@", key);
		keyHint = [keyHint stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		keyHint = [keyHint stringByReplacingOccurrencesOfString:@"jr:itext('" withString:@""];
		keyHint = [keyHint stringByReplacingOccurrencesOfString:@"')" withString:@""];
		//NSLog(@"after %@", key);
		NSString *thisHint = [textIdDic objectForKey:keyHint];
		thisHint = [thisHint stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if (thisHint != nil) {
			[currentHint release];
			currentHint = [thisHint mutableCopy];
		}
		//NSLog(@"%@", currentLabel);
	}
	
	//Fillout item-label and item-hint if there is a reference to the header
	if(insideItem && [elementName isEqualToString:@"label"] && [[attributeDict allKeys] count] > 0){
		NSString *keyItemLabel = [attributeDict objectForKey:@"ref"];
		//NSLog(@"before %@", key);
		keyItemLabel = [keyItemLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		keyItemLabel = [keyItemLabel stringByReplacingOccurrencesOfString:@"jr:itext('" withString:@""];
		keyItemLabel = [keyItemLabel stringByReplacingOccurrencesOfString:@"')" withString:@""];
		//NSLog(@"after %@", key);
		NSString *thisItemLabel = [textIdDic objectForKey:keyItemLabel];
		thisItemLabel = [thisItemLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if (thisItemLabel != nil) {
			[currentItemLabel release];
			currentItemLabel = [thisItemLabel mutableCopy];
		}
	}else if (insideItem && [elementName isEqualToString:@"value"] && [[attributeDict allKeys] count] > 0) {
		NSString *keyItemValue = [attributeDict objectForKey:@"ref"];
		//NSLog(@"before %@", key);
		keyItemValue = [keyItemValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		keyItemValue = [keyItemValue stringByReplacingOccurrencesOfString:@"jr:itext('" withString:@""];
		keyItemValue = [keyItemValue stringByReplacingOccurrencesOfString:@"')" withString:@""];
		//NSLog(@"after %@", key);
		NSString *thisItemValue = [textIdDic objectForKey:keyItemValue];
		thisItemValue = [thisItemValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if (thisItemValue != nil) {
			[currentItemValue release];
			currentItemValue = [thisItemValue mutableCopy];
		}
		
		//NSLog(@"%@", currentLabel);
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);
	
	if([elementName isEqualToString:@"h:head"]){
		insideHead = NO;
	}else if (insideHead && [elementName isEqualToString:@"text"]) {
		//NSDictionary *idDic = [NSDictionary dictionaryWithObjectsAndKeys:idValue, idKey, nil];
		//NSLog(@"Value: %@ Key: %@", idValue, idKey);
		[textIdDic setObject:idValue forKey:idKey];
	}
	
	if ([elementName isEqualToString:@"h:body"]) {
		insideBody = NO;
	}else if (insideBody && ([elementName isEqualToString:@"input"] || [elementName isEqualToString:@"select"] || [elementName isEqualToString:@"select1"] || [elementName isEqualToString:@"upload"])) {
		NSString *thisLabel = [currentLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSString *thisHint = [currentHint stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		//NSLog(@"end: %@", thisLabel);
		
		//Set type
		NSMutableString *typeFromBindDic = [bindDic objectForKey:currentType];
		if([typeFromBindDic isEqualToString:@"unknown"]){
			[bindDic setObject:elementName forKey:currentType];
			//thisType = elementName;
		}
		//NSLog(@"Search for key: %@ - result: %@", currentType, thisType);
        
		if(currentType != nil && thisLabel != nil && thisHint != nil){
			entryItem.type = currentType;
			entryItem.label = thisLabel;
			entryItem.hint = thisHint;
			if ([currentSelectionItems count] != 0) {
				entryItem.items = currentSelectionItems;
			}
			[newReport.entries addObject:entryItem];
		}
	}else if ([elementName isEqualToString:@"item"]) {
		NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
		NSString *thisItemLabel = [currentItemLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSString *thisItemValue = [currentItemValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		[itemDic setObject:thisItemLabel forKey:@"itemLabel"];
		[itemDic setObject:thisItemValue forKey:@"itemValue"];
		[currentSelectionItems addObject:itemDic];
		[itemDic release];
		insideItem = NO;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	
	if([currentElement isEqualToString:@"h:title"]){
		[currentTitle appendString:string];
	}
	
	if(insideHead && [currentElement isEqualToString:@"value"]){
		[idValue appendString:string];
	}
	
	if(insideBody && !insideItem && [currentElement isEqualToString:@"label"]){
		[currentLabel appendString:string];
	}else if (insideBody && !insideItem && [currentElement isEqualToString:@"hint"]) {
		[currentHint appendString:string];
	}else if (insideBody && insideItem && [currentElement isEqualToString:@"label"]) {
		[currentItemLabel appendString:string];
	}else if (insideBody && insideItem && [currentElement isEqualToString:@"value"]) {
		[currentItemValue appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//NSLog(@"all done!");
	//NSLog(@"numitems in form: %d", [formItems count]);
	//NSLog(@"num items in textiddic keys %d", [[textIdDic allKeys] count]);
	/*
	for(NSDictionary *dic in formItems){
		NSLog(@"%@ - label: %@, hint: %@", [dic objectForKey:@"type"], [dic objectForKey:@"label"], [dic objectForKey:@"hint"]);
		if ([dic objectForKey:@"items"]) {
			NSLog(@"itamz: %d", [[dic objectForKey:@"items"] count]);
			for(NSDictionary *dic2 in [dic objectForKey:@"items"]){
				NSLog(@"ItamLabel: %@, ItamValue: %@", [dic2 objectForKey:@"itemLabel"], [dic2 objectForKey:@"itemValue"]);
			}
		}
	}*/
	
	//Call back to viewcontroller
	ViewWorldAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	SelectFormViewController *vc = (SelectFormViewController *)delegate.selectFormViewController.navigationController.topViewController;
	NSString *thisTitle = [currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//vc.parsedTitle = thisTitle;
	//newReport.title = thisTitle;
    newReport.origTitle = thisTitle;
	newReport.dataId = dataId;
	newReport.bindDic = bindDic;
	//[vc performSelectorOnMainThread:@selector(doneParsing:) withObject:formItems waitUntilDone:NO];
	[vc performSelectorOnMainThread:@selector(doneParsing:) withObject:newReport waitUntilDone:NO];
	
}

-(void)dealloc{
	[dataId release];
	[newReport release];
	[entryItem release];
	[currentTitle release];
	[currentType release];
	[currentLabel release];
	[currentHint release];
	[currentItemLabel release];
	[currentItemValue release];
	[item release];
	[idKey release];
	[idValue release];
	
	[bindDic release];
	[textIdDic release];
	[currentElement release];
	[formItems release];
	
	[super dealloc];
	
}

@end

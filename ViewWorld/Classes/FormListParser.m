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

#import "FormListParser.h"


@implementation FormListParser

@synthesize formItems;
@synthesize currentElement;


-(NSArray *)parseForm:(NSData *)data{
	formItems = [[NSMutableArray alloc] init];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	
	//NSLog(@"returning");
	return formItems;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{	
	//NSLog(@"found file and started parsing");	
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"parse error: %@", parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    //NSLog(@"found this element: %@", elementName);
	currentElement = elementName;
	
	if ([elementName isEqualToString:@"form"]) {
		//[currentType release];
		[currentUrl release];
		[currentTitle release];
		[item release];

		currentUrl = [[attributeDict objectForKey:@"url"] retain];
		currentTitle = [[NSMutableString alloc] init];
		item = [[NSMutableDictionary alloc] init];
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);	
	if ([elementName isEqualToString:@"form"]) {
		
		[item setObject:[currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"title"];
		[item setObject:[currentUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"url"];
		
		[formItems addObject:item];
		//NSLog(@"form count %d", [formItems count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	if([currentElement isEqualToString:@"form"]){
		[currentTitle appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//NSLog(@"all done!");
	[item release];
}

-(void)dealloc{
	[currentElement release];
	[formItems release];
	[super dealloc];
}

@end

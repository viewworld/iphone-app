//
//  FormListParser.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/24/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

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

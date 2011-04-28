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

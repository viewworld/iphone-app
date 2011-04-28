//
//  FormParserOperation.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/5/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FormParserOperation : NSOperation {
	NSData *formData;
}
@property(nonatomic, retain) NSData *formData;

@end

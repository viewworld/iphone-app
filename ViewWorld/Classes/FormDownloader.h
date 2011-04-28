//
//  FormDownloader.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/25/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FormDownloaderDelegate <NSObject>
@optional
- (void)formDownloaded;
@end

@interface FormDownloader : NSObject {
	NSMutableData *formData;
	NSDictionary *formDictionary;
	
	id <FormDownloaderDelegate, NSObject> delegate;
}
@property(nonatomic, retain) NSMutableData *formData;
@property(nonatomic, retain) NSDictionary *formDictionary;
@property (nonatomic, assign)  id <FormDownloaderDelegate> delegate;

-(id)initWithFormDic:(NSDictionary *)formDic;

@end

//
//  FormUploader.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 2/18/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReportUploaderDelegate <NSObject>
@optional
- (void)reportUploaded:(Report *)report statuscode:(int)code;
@end

@interface ReportUploader : NSObject <UIAlertViewDelegate>{
	Report *currentReport;
	
	id <ReportUploaderDelegate, NSObject> delegate;
}
@property(nonatomic, retain) Report *currentReport;
@property (nonatomic, assign)  id <ReportUploaderDelegate> delegate;

-(id)initWithReport:(Report *)aReport;

@end

//
//  FormDoneViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/10/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FormDoneViewController : UIViewController {
	Report *currentReport;
}
@property(nonatomic, retain) Report *currentReport;

@end

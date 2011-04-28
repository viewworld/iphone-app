//
//  VideoViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 3/23/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseEntryViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController : BaseEntryViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *imagePicker;
    UIImageView *imageView;
    
    //MPMoviePlayerController *moviePlayer;
    //MPMoviePlayerViewController *moviePlayerVC;
    UIButton *playSavedMovieButton;
    UIButton *videoButton;
    
    NSURL *currentUrl;
}
@property(nonatomic, retain) NSURL *currentUrl;

@end

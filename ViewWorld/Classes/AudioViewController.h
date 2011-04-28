//
//  AudioViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 3/23/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseEntryViewController.h"

@interface AudioViewController : BaseEntryViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>{
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    
    UIButton *playButton;
    UIButton *stopButton;
    UIButton *recordButton;
    
    UILabel *fileExistsLabel;
    
    BOOL dataAlreadyExisted;
}

@end

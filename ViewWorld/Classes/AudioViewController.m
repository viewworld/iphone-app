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

#import "AudioViewController.h"

typedef enum {
    audioButtonStateRecord = 0,
    audioButtonStateRecordNew,
}audioButtonState;

@implementation AudioViewController

-(NSString *)soundFilePath{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"tempAudio.caf"];
    
    return soundFilePath;
}


-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
    if (!dataAlreadyExisted && [recordButton tag] == audioButtonStateRecordNew) {
        NSURL *url = [NSURL fileURLWithPath:[self soundFilePath]];
        NSData *theData = [[NSData alloc] initWithContentsOfURL:url];
        //NSLog(@"data length %d", [theData length]);
        thisEntry.audioData = theData;
        [theData release];
    }else{
        //NSLog(@"not saving new data (or any)");
    }    
}

-(void)recordButtonPressed{
    if (!audioRecorder.recording){
        playButton.enabled = NO;
        playButton.alpha = 0.5;
        stopButton.enabled = YES;
        stopButton.alpha = 1.0;
        recordButton.enabled = NO;
        recordButton.alpha = 0.5;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        if([audioRecorder record]){
            //NSLog(@"STARTED recording");
        }else {
            //NSLog(@"NOT STARTED!!!!!!!!!!!!!!!!!!!!!");
        }
    }

}

-(void)playButtonPressed{
    if (!audioRecorder.recording){
        stopButton.enabled = YES;
        stopButton.alpha = 1.0;
        recordButton.enabled = NO;
        recordButton.alpha = 0.5;
        
        if (audioPlayer)
            [audioPlayer release];
        NSError *error;
        
        if (!dataAlreadyExisted) {
            //NSLog(@"playing from recorder");
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:&error];
        }else{
           // NSLog(@"playing saved data");
            Entry *thisEntry = [currentReport.entries objectAtIndex:index];
            audioPlayer = [[AVAudioPlayer alloc] initWithData:thisEntry.audioData error:&error];
        }
        
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@", [error localizedDescription]);
        else{
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [audioPlayer play];
        }
    }

}

-(void)stopButtonPressed{
    stopButton.enabled = NO;
    stopButton.alpha = 0.5;
    playButton.enabled = YES;
    playButton.alpha = 1.0;
    recordButton.enabled = YES;
    recordButton.alpha = 1.0;
    
    if (audioRecorder.recording){
        [audioRecorder stop];
        [recordButton setTitle:NSLocalizedString(@"Record new audio", @"recordButton_title_record_new") forState:UIControlStateNormal];
        [recordButton setTag:audioButtonStateRecordNew];
        dataAlreadyExisted = NO;
        if ([fileExistsLabel isHidden]) {
            fileExistsLabel.hidden = NO;
        }
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    
    fileExistsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 220, 40)];
    fileExistsLabel.text = NSLocalizedString(@"A sound file is saved.", @"fileExistsLabel");
    fileExistsLabel.backgroundColor = [UIColor greenColor];
    fileExistsLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:fileExistsLabel];
    fileExistsLabel.hidden = YES;
    
    playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake(50, 150, 220, 40);
    [playButton setTitle:NSLocalizedString(@"Play", @"playButton_title") forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    playButton.enabled = NO;
    playButton.alpha = 0.5;
    
    stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopButton.frame = CGRectMake(50, 200, 220, 40);
    [stopButton setTitle:NSLocalizedString(@"Stop", @"stopButton_title") forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    stopButton.enabled = NO;
    stopButton.alpha = 0.5;
    
    recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recordButton.frame = CGRectMake(50, 250, 220, 40);
    [recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordButton];
    
    Entry *thisEntry = [currentReport.entries objectAtIndex:index];
    if ([thisEntry.audioData length] > 0) {
        dataAlreadyExisted = YES;
        fileExistsLabel.hidden = NO;
        playButton.enabled = YES;
        playButton.alpha = 1.0;
        [recordButton setTitle:NSLocalizedString(@"Record new audio", @"recordButton_title_record_new") forState:UIControlStateNormal];
        [recordButton setTag:audioButtonStateRecordNew];
    }else{
        fileExistsLabel.hidden = YES;
        playButton.enabled = NO;
        playButton.alpha = 0.5;
        [recordButton setTitle:NSLocalizedString(@"Record", @"recordButton_title_record") forState:UIControlStateNormal];
        [recordButton setTag:audioButtonStateRecord];
    }
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:[self soundFilePath]];
    
    NSDictionary *recordSettings = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], 
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], 
                                    AVSampleRateKey,
                                    nil];
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];
    
    if (error){
        NSLog(@"error: %@", [error localizedDescription]);
    }else {
        [audioRecorder prepareToRecord];
    }
    
    [super viewDidLoad];
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc{
    [fileExistsLabel release];
    [audioRecorder release];
    [audioPlayer release];
    //[playButton release];
    //[stopButton release];
    //[recordButton release];
    [super dealloc];
}

#pragma mark Audio Player Delegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    recordButton.enabled = YES;
    recordButton.alpha = 1.0;
    stopButton.enabled = NO;
    stopButton.alpha = 0.5;
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"Decode Error occurred");
}

#pragma mark Audio Recorder Delegate

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"Encode Error occurred");
}

@end

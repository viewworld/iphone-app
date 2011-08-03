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

#import "VideoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#define kMoviePlayerTag 10

@implementation VideoViewController

@synthesize currentUrl;

-(void)playSavedMovieButtonPressed{
    // Register for the playback finished notification
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:self.currentUrl];
    moviePlayerVC.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    moviePlayerVC.moviePlayer.shouldAutoplay = NO;
    if([moviePlayerVC.moviePlayer shouldAutoplay]) NSLog(@"hmm");
    //moviePlayerVC.moviePlayer.view.frame = CGRectMake(160, 133, 0, 0);
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self presentModalViewController:moviePlayerVC animated:YES];
    [moviePlayerVC release];
  
}

-(NSString *)videoFilePath{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *videoFilePath = [docsDir stringByAppendingPathComponent:@"tempVideo.mov"];
    
    return videoFilePath;
}


-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
    if (self.currentUrl != nil) {
        NSData *theData = [[NSData alloc] initWithContentsOfURL:self.currentUrl];
        //NSLog(@"video data length %d", [theData length]);
        thisEntry.videoData = theData;
        [theData release];
    }else{
        //NSLog(@"no video to save");
    }
}

-(void)videoButtonPressed{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES){
        //if (!imagePicker) {
            
            NSArray *array = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            if ([array containsObject:(NSString *)kUTTypeMovie]) {
                imagePicker = [[UIImagePickerController alloc] init]; 
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = NO;
                //imagePicker.showsCameraControls = NO;
                imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
                [imagePicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModeVideo];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No video recording", @"videoViewController_alert_title") 
                                                                message:NSLocalizedString(@"This device does not support video recording.", @"videoViewController_alert_message") 
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"Ok", @"videoViewController_alert_ok") 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            
        //}
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
		[self presentModalViewController:imagePicker animated:YES];
		
	}else {
		NSLog(@"camera not available");
	
    }
}

-(void)videoRollButtonPressed{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == YES){
        //if (!imagePicker) {
            NSArray *array = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            if ([array containsObject:(NSString *)kUTTypeMovie]) {
                imagePicker = [[UIImagePickerController alloc] init]; 
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                imagePicker.allowsEditing = NO;
                //imagePicker.showsCameraControls = NO;
                imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No video recording", @"videoViewController_alert_title") 
                                                                message:NSLocalizedString(@"This device does not support video recording.", @"videoViewController_alert_message") 
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"Ok", @"videoViewController_alert_ok") 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            
        //}
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
		[self presentModalViewController:imagePicker animated:YES];
		
	}else {
		NSLog(@"camera roll not available");
        
    }
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    videoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	videoButton.frame = CGRectMake(10, 100, 300, 40);
	[videoButton addTarget:self action:@selector(videoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoButton];
    
    videoRollButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	videoRollButton.frame = CGRectMake(10, 150, 300, 40);
	[videoRollButton addTarget:self action:@selector(videoRollButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoRollButton];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 250, 180, 110)];//CGRectMake(100, 200, 120, 160)
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    playSavedMovieButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playSavedMovieButton setTitle:NSLocalizedString(@"Play saved video", @"playSavedMovieButton_title") forState:UIControlStateNormal];
    [playSavedMovieButton addTarget:self action:@selector(playSavedMovieButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    playSavedMovieButton.frame = CGRectMake(70, 200, 180, 40);
    [self.view addSubview:playSavedMovieButton];
    
    Entry *thisEntry = [currentReport.entries objectAtIndex:index];
    if([thisEntry.videoData length] > 0){
        [videoButton setTitle:NSLocalizedString(@"Record new video", @"videoButton_title") forState:UIControlStateNormal];
        [videoRollButton setTitle:NSLocalizedString(@"Choose new video from roll", @"videoRollButton_title") forState:UIControlStateNormal];
        [thisEntry.videoData writeToFile:[self videoFilePath] atomically:YES];
        self.currentUrl = [NSURL fileURLWithPath:[self videoFilePath]];
        MPMoviePlayerController *aMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.currentUrl];
        aMoviePlayer.shouldAutoplay = NO;
        imageView.image = [aMoviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [aMoviePlayer release];
    }else{
        [videoButton setTitle:NSLocalizedString(@"Start video recorder", @"videoButton_title") forState:UIControlStateNormal];
        [videoRollButton setTitle:NSLocalizedString(@"Choose video from roll", @"videoRollButton_title") forState:UIControlStateNormal];
        playSavedMovieButton.hidden = YES;
    }
    
    [super viewDidLoad];
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc{
    [currentUrl release];
    [imagePicker release];
    [imageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.currentUrl = [info objectForKey:@"UIImagePickerControllerMediaURL"];
    //NSLog(@"%@", [movieUrl absoluteString]);
    MPMoviePlayerController *aMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.currentUrl];
    aMoviePlayer.shouldAutoplay = NO;
    imageView.image = [aMoviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [aMoviePlayer release];
    playSavedMovieButton.hidden = NO;
    [videoButton setTitle:NSLocalizedString(@"Record new video", @"videoButton_title") forState:UIControlStateNormal];
    [videoRollButton setTitle:NSLocalizedString(@"Choose new video from roll", @"videoRollButton_title") forState:UIControlStateNormal];
    
	[self dismissModalViewControllerAnimated:YES];
}

@end

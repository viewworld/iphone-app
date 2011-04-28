//
//  VideoViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 3/23/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "VideoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#define kMoviePlayerTag 10

@implementation VideoViewController

@synthesize currentUrl;

/*-(void)moviePlayerCallback:(NSNotification*)aNotification{
    NSLog(@"notif name: %@", aNotification.name);
    MPMoviePlayerController *aMoviePlayer = [aNotification object];
    //[aMoviePlayer stop];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name: MPMoviePlayerPlaybackDidFinishNotification object:aMoviePlayer];
    
    //[aMoviePlayer release];
    //[self dismissModalViewControllerAnimated:YES];
    //[moviePlayerVC release];
}*/

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
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerVC.moviePlayer];
    
    
    //[aMoviePlayer play];
    //aMoviePlayer.fullscreen = YES;
    
    /*MPMoviePlayerController *aMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.currentUrl];
    aMoviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    aMoviePlayer.view.frame = CGRectMake(160, 133, 0, 0);
    [self.view addSubview:aMoviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerCallback:) name:MPMoviePlayerDidExitFullscreenNotification object:aMoviePlayer];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [aMoviePlayer play];
    aMoviePlayer.fullscreen = YES;*/
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
        if (!imagePicker) {
            
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No video recording" message:@"This device does not support video recording." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            
        }
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
		[self presentModalViewController:imagePicker animated:YES];
		
	}else {
		NSLog(@"camera not available");
	}
    
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	UIInterfaceOrientation orientation = self.interfaceOrientation;
	if (orientation == UIInterfaceOrientationPortrait) {
		NSLog(@"portrait");

	}else {
		NSLog(@"landscape");

	}
	
}*/

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    videoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	videoButton.frame = CGRectMake(50, 100, 220, 40);
	[videoButton addTarget:self action:@selector(videoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoButton];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 200, 160, 160)];//CGRectMake(100, 200, 120, 160)
    [self.view addSubview:imageView];
    
    playSavedMovieButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playSavedMovieButton setTitle:@"Play saved video" forState:UIControlStateNormal];
    [playSavedMovieButton addTarget:self action:@selector(playSavedMovieButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    playSavedMovieButton.frame = CGRectMake(50, 150, 220, 40);
    [self.view addSubview:playSavedMovieButton];
    
    Entry *thisEntry = [currentReport.entries objectAtIndex:index];
    if([thisEntry.videoData length] > 0){
        [videoButton setTitle:@"Record new video" forState:UIControlStateNormal];
        [thisEntry.videoData writeToFile:[self videoFilePath] atomically:YES];
        self.currentUrl = [NSURL fileURLWithPath:[self videoFilePath]];
        MPMoviePlayerController *aMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.currentUrl];
        aMoviePlayer.shouldAutoplay = NO;
        imageView.image = [aMoviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [aMoviePlayer release];
    }else{
        [videoButton setTitle:@"Start video recorder" forState:UIControlStateNormal];
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
    /*
    moviePlayer = nil;
    [moviePlayer release];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    //moviePlayer.controlStyle = MPMovieControlStyleNone;
    imageView.image = [moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    moviePlayer.view.tag = kMoviePlayerTag;
    [self.view addSubview:moviePlayer.view];
    */
    playSavedMovieButton.hidden = NO;
    [videoButton setTitle:@"Record new video" forState:UIControlStateNormal];
    
	[self dismissModalViewControllerAnimated:YES];
}

@end

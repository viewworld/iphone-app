    //
//  ImageViewController.m
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import "ImageViewController.h"


@implementation ImageViewController

@synthesize imageView;

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	NSData *dataObj = UIImageJPEGRepresentation(imageView.image, 1.0);
	thisEntry.imageData = dataObj;
}

// Start the camera if the record image button is pressed

-(void)imageButtonPressed{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES){
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; 
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePicker.allowsEditing = NO;
		
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}else {
		NSLog(@"camera not available");
	}

}

// Open the camera roll if the "choose from camera roll" button is pressed

-(void)rollButtonPressed{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == YES){
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; 
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		imagePicker.allowsEditing = NO;
		
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}else {
		NSLog(@"camera roll not available");
	}
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    //Draw the button for choose from camera roll
    UIButton *rollButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	rollButton.frame = CGRectMake(10, 150, 300, 40);
	[rollButton addTarget:self action:@selector(rollButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[rollButton setTitle:NSLocalizedString(@"Choose from camera roll", @"rollButton_title") forState:UIControlStateNormal];
    
    //Draw the button for starting camera
	UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	imageButton.frame = CGRectMake(10, 100, 300, 40);
	[imageButton addTarget:self action:@selector(imageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[imageButton setTitle:NSLocalizedString(@"Start camera", @"imageButton_title") forState:UIControlStateNormal];
	
    //create a view for the recorded image
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, 220, 160)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //fill in image data in the image image view
    Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	if (thisEntry.imageData != nil) {
		UIImage *thisImage = [[UIImage alloc] initWithData:thisEntry.imageData];
		imageView.image = thisImage;
		[thisImage release];
	}
	
	[self.view addSubview:imageView];
	[self.view addSubview:imageButton];
    [self.view addSubview:rollButton];
	
    [super viewDidLoad];
}

- (void)dealloc {
	[imageView release];
    [super dealloc];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	imageView.image = image;
	[self dismissModalViewControllerAnimated:YES];
}


@end

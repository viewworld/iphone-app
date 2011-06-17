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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	imageButton.frame = CGRectMake(10, 100, 300, 40);
	[imageButton addTarget:self action:@selector(imageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[imageButton setTitle:@"Start camera" forState:UIControlStateNormal];
	
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 150, 120, 160)];
    
    Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	if (thisEntry.imageData != nil) {
		UIImage *thisImage = [[UIImage alloc] initWithData:thisEntry.imageData];
		imageView.image = thisImage;
		[thisImage release];
	}
	
	[self.view addSubview:imageView];
	[self.view addSubview:imageButton];
	
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

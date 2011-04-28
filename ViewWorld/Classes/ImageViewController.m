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
	[rollButton setTitle:@"Choose from camera roll" forState:UIControlStateNormal];
    
    //Draw the button for starting camera
	UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	imageButton.frame = CGRectMake(10, 100, 300, 40);
	[imageButton addTarget:self action:@selector(imageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[imageButton setTitle:@"Start camera" forState:UIControlStateNormal];

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

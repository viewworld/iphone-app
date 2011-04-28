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

#import "GPSViewController.h"


@implementation GPSViewController

@synthesize _mapView;
@synthesize accuracyLabel;
@synthesize gpsButton;
@synthesize latLabel, lngLabel;

-(void)startGPS{
	if ([[gpsButton titleForState:UIControlStateNormal] isEqualToString:@"Start recording"] || [[gpsButton titleForState:UIControlStateNormal] isEqualToString:@"Record new coordinate"]) {
		_mapView.showsUserLocation = YES;
		[_mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
		[gpsButton setTitle:@"Save recording" forState:UIControlStateNormal];
	}else {
		_mapView.showsUserLocation = NO;
		[_mapView.userLocation removeObserver:self forKeyPath:@"location"];
		[gpsButton setTitle:@"Record new coordinate" forState:UIControlStateNormal];
	}

	
	
}

-(void)addValue{
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	//thisEntry.location = _mapView.userLocation.location;
	if (receivedNewPos) {
		//NSLog(@"saving pos");
		thisEntry.lat = _mapView.userLocation.location.coordinate.latitude;
		thisEntry.lng = _mapView.userLocation.location.coordinate.longitude;
		thisEntry.horAcc = _mapView.userLocation.location.horizontalAccuracy;
		thisEntry.verAcc = _mapView.userLocation.location.verticalAccuracy;
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	receivedNewPos = YES;
	accuracyLabel.text = [NSString stringWithFormat:@"%.0fm", _mapView.userLocation.location.horizontalAccuracy];
	
	if(_mapView.userLocation.location.horizontalAccuracy < 40.0){
		accuracyLabel.backgroundColor = [UIColor greenColor];
	}else if(_mapView.userLocation.location.horizontalAccuracy < 80.0){
		accuracyLabel.backgroundColor = [UIColor yellowColor];	
	}else if(_mapView.userLocation.location.horizontalAccuracy > 80.0){
		accuracyLabel.backgroundColor = [UIColor redColor];
	}
	
	latLabel.text = [NSString stringWithFormat:@"Lat: %f", _mapView.userLocation.location.coordinate.latitude];
	lngLabel.text = [NSString stringWithFormat:@"Lng: %f", _mapView.userLocation.location.coordinate.longitude];
}

-(void)viewWillDisappear:(BOOL)animated{
	if ([_mapView showsUserLocation]) {
		//NSLog(@"stopping gps");
		_mapView.showsUserLocation = NO;
		[_mapView.userLocation removeObserver:self forKeyPath:@"location"];
		[gpsButton setTitle:@"Record new coordinate" forState:UIControlStateNormal];
	}
	receivedNewPos = NO;
	[super viewWillDisappear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
	//_mapView.showsUserLocation = YES;
	//[_mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
	[super viewDidAppear:YES];
}

-(void)viewDidLoad{
	
	receivedNewPos = NO;
	
	UILabel *accuracyHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 300, 30)];
	accuracyHeaderLabel.text = @"GPS Accuracy:";
	accuracyHeaderLabel.textAlignment = UITextAlignmentCenter;
	accuracyHeaderLabel.backgroundColor = [UIColor clearColor];
	
	accuracyLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 150, 100, 40)];
	accuracyLabel.textAlignment = UITextAlignmentCenter;
	accuracyLabel.backgroundColor = [UIColor redColor];	
	
	latLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 20)];
	latLabel.textAlignment = UITextAlignmentCenter;
	latLabel.backgroundColor = [UIColor clearColor];
	
	lngLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 300, 20)];
	lngLabel.textAlignment = UITextAlignmentCenter;
	lngLabel.backgroundColor = [UIColor clearColor];
	
	Entry *thisEntry = [currentReport.entries objectAtIndex:index];
	if (thisEntry.lat != 0.0 && thisEntry.lng != 0.0 && thisEntry.horAcc != 0.0) {
		latLabel.text = [NSString stringWithFormat:@"Lat: %f", thisEntry.lat];
		lngLabel.text = [NSString stringWithFormat:@"Lng: %f", thisEntry.lng];
		accuracyLabel.text = [NSString stringWithFormat:@"%.0fm", thisEntry.horAcc];
		if(thisEntry.horAcc < 40.0){
			accuracyLabel.backgroundColor = [UIColor greenColor];
		}else if(thisEntry.horAcc < 80.0){
			accuracyLabel.backgroundColor = [UIColor yellowColor];	
		}else if(thisEntry.horAcc > 80.0){
			accuracyLabel.backgroundColor = [UIColor redColor];
		}
	}
	
	
	gpsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	gpsButton.frame = CGRectMake(10, 270, 300, 40);
    if (accuracyLabel.text == nil) {
        [gpsButton setTitle:@"Start recording" forState:UIControlStateNormal];
    }else  {
        [gpsButton setTitle:@"Record new coordinate" forState:UIControlStateNormal];
    }
	
	[gpsButton addTarget:self action:@selector(startGPS) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:latLabel];
	[self.view addSubview:lngLabel];
	[self.view addSubview:gpsButton];
	
	[self.view addSubview:accuracyLabel];
	[self.view addSubview:accuracyHeaderLabel];
	[accuracyHeaderLabel release];
	
	_mapView = [[MKMapView alloc] init];
	//_mapView.showsUserLocation = YES;
	
	[super viewDidLoad];
}

- (void)dealloc {
	[latLabel release];
	[lngLabel release];
	//[gpsButton release];
	[accuracyLabel release];
	[_mapView release];
    [super dealloc];
}


@end

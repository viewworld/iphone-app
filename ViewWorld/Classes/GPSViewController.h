//
//  GPSViewController.h
//  ViewWorld
//
//  Created by Uffe Overgaard Koch on 1/7/11.
//  Copyright 2011 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseEntryViewController.h"
#import <MapKit/MapKit.h>

@interface GPSViewController : BaseEntryViewController {
	UILabel *accuracyLabel;
	UILabel *latLabel;
	UILabel *lngLabel;
	MKMapView *_mapView;
	
	UIButton *gpsButton;
	BOOL receivedNewPos;
}
@property(nonatomic, retain) UIButton *gpsButton;
@property(nonatomic, retain) UILabel *accuracyLabel;
@property(nonatomic, retain) UILabel *latLabel;
@property(nonatomic, retain) UILabel *lngLabel;
@property(nonatomic, retain) MKMapView *_mapView;

@end

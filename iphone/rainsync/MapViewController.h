//
//  MapViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import "RidingManager.h"
#import "RouteMapViewController.h"

@interface MapViewController : RouteMapViewController <UIActionSheetDelegate>
{


    RidingManager *ridingManager;
    BOOL isHeading;
}
- (IBAction)changeMap:(id)sender;
- (IBAction)setHeading:(id)sender;
- (NSInteger)getUserNum:(NSString*)username;
- (void)addPoint:(int)pos withLocation:(CLLocation *)newLocation;
@end

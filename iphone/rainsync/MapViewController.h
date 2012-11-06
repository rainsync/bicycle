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
#import "CSRouteAnnotation.h"
#import "CSRouteView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    NSMutableDictionary* _routeViews;
    RidingManager *ridingManager;

    
}
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@end

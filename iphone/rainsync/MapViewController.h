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
#import "CrumbPath.h"
#import "CrumbPathView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>
{

    RidingManager *ridingManager;
    NSMutableArray *users;
    NSMutableArray *route_lines;
    NSMutableArray *route_views;
    NSArray *line_color;
    CLLocation * my_loc;
    
    
}
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
- (NSInteger)getUserNum:(NSString*)username;
- (void)addPoint:(int)pos withLocation:(CLLocation *)newLocation;
@end

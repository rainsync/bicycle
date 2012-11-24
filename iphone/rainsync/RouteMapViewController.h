//
//  MapManager.h
//

//
//  Created by xorox64 on 12. 11. 19..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "PictureAnnotationView.h"

#import <MapKit/MapKit.h>

@interface RouteMapViewController : UIViewController <MKMapViewDelegate>
{
    NSMutableArray *users;
    NSMutableArray *route_lines;
    NSMutableArray *route_views;
    NSMutableArray *profile_annotation;
    NSMutableArray *profile_views;
    NSArray *line_color;
    int width;

}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
- (NSInteger) getUserNum:(NSInteger)userid;
- (NSInteger) createUser:(NSInteger)userid;
- (void) addPoint:(int)pos withLocation:(CLLocation *)newLocation;
- (void) clear;

@end

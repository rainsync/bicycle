//
//  MapViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        line_index=0;
        line_color = [[NSArray alloc] initWithArray:@[[UIColor redColor],[UIColor greenColor], [UIColor blueColor], [UIColor blackColor], [UIColor whiteColor]]];
        points = malloc(sizeof(MKMapPoint*)*8);
        point_count = malloc(sizeof(int)*8);
        
        users = [[NSMutableArray alloc] init];
        route_lines = [[NSMutableArray alloc]init];
        route_views = [[NSMutableArray alloc]init];
        
        my_loc =nil;
        
        
        [self getUserNum:@"me"];

        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    RidingManager *ridingManager =[RidingManager getInstance];
    
    if([ridingManager isRiding]){
    
    }
    
    [ridingManager addTarget:self];
    
    

        // Do any additional setup after loading the view from its nib.
}

- (NSInteger) getUserNum:(NSString*)username
{

    for(int i=0; i<[users count]; ++i){
        NSString* name= [users objectAtIndex:i];
        if([name isEqualToString:username])
            return i;
        
    }
    
    [users addObject:username];
    [route_lines addObject:[NSNull null]];
    [route_views addObject:[NSNull null]];
    
    int i=[users count]-1;
    MKMapPoint *arr= malloc(sizeof(CLLocationCoordinate2D)* 128);
    points[i]=arr;
    point_count[i]=0;
    return i;
    
}
- (void) addPoint:(int)pos withLocation:(CLLocation *)newLocation
{
    MKMapPoint *point = points[pos];
    if(point_count[pos]>=128)
        point_count[pos]=0;
    
    point[point_count[pos]++]=MKMapPointForCoordinate(newLocation.coordinate);
    
    MKPolyline *prev_line = [route_lines objectAtIndex:pos];
    if(prev_line != [NSNull null])
        [self.mapView removeOverlay:prev_line];
    
    MKPolyline *line = [MKPolyline polylineWithPoints:point count:point_count[pos]];
    [route_lines replaceObjectAtIndex:pos withObject:line];
    [self.mapView addOverlay:line];
    
}

- (void)locationManager:(RidingManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    int num= [self getUserNum:@"me"];
    [self addPoint:num withLocation:newLocation];
    

    if(my_loc==nil){
        my_loc=newLocation;
        [self setMapCenter:newLocation.coordinate];
    }else{
        if([my_loc distanceFromLocation:newLocation]>=100.0f){
            [self setMapCenter:newLocation.coordinate];
            my_loc=newLocation;
            
        }
    }
    
    
//    CLLocation *location = newLocation;
//    if(oldLocation)
//        if([oldLocation distanceFromLocation:newLocation] >= 100.0f)
//        {
//            
//            [self setMapCenter:location.coordinate];
//        }
    
//    for(NSObject* key in [_routeViews allKeys])
//	{
//		CSRouteView* routeView = [_routeViews objectForKey:key];
//		routeView.hidden = NO;
//		[routeView regionChanged];
//	}

    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    [self.mapView setTransform:CGAffineTransformMakeRotation(-1 * newHeading.magneticHeading * M_PI / 180)];
    
}


-(void)setMapCenter:(CLLocationCoordinate2D)location
{
    //[self.mapView setCenterCoordinate:location zoomLevel:13 animated:YES];
 
    
    NSLog(@"Current Location : %f, %f",location.latitude,location.longitude);
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.001;
    span.longitudeDelta=0.001;
    region.span=span;
    //location.latitude=(float *)(self.appDelegate.currentLocationLatitude);
    //location.latitude=self.appDelegate.currentLocationLongitude;
    region.center=location;
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    
    

}


- (IBAction)changeToMap:(id)sender {
    self.mapView.mapType = MKMapTypeStandard;
}
- (IBAction)changeToSatellite:(id)sender {
    self.mapView.mapType = MKMapTypeSatellite;
}
- (IBAction)changeToHybrid:(id)sender {
    self.mapView.mapType = MKMapTypeHybrid;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}




- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
    for(int i=0; i<[route_lines count]; ++i){
        if(overlay == [route_lines objectAtIndex:i]){
            MKPolylineView *view = [route_views objectAtIndex:i];
            
                if(view == [NSNull null])
                {
                    view = [[[MKPolylineView alloc] initWithPolyline:route_lines[i]] autorelease];
                    view.fillColor = [UIColor redColor];
                    view.strokeColor = [UIColor redColor];
                    view.lineWidth = 3;
                }
            overlayView = view;
            break;
        }
    }
    
        return overlayView;

}



- (void)viewDidUnload {
    [_mapView release];
    _mapView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [_mapView release];
    [super dealloc];
}

@end

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

        line_color = [[NSArray alloc] initWithArray:@[[UIColor redColor],[UIColor greenColor], [UIColor blueColor], [UIColor blackColor], [UIColor whiteColor]]];
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
    [self setTrackUser:self];
    
    
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
    return i;
    
}
- (void) addPoint:(int)pos withLocation:(CLLocation *)newLocation
{


    CrumbPath *prev_line = [route_lines objectAtIndex:pos];
    if(prev_line == [NSNull null])
    {
        prev_line = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
        [self.mapView addOverlay:prev_line];
    }else{
    
        MKMapRect updateRect = [prev_line addCoordinate:newLocation.coordinate];
        
        if (!MKMapRectIsNull(updateRect) && route_views[pos]!=[NSNull null])
        {
            // There is a non null update rect.
            // Compute the currently visible map zoom scale
            MKZoomScale currentZoomScale = (CGFloat)(_mapView.bounds.size.width / _mapView.visibleMapRect.size.width);
            // Find out the line width at this zoom scale and outset the updateRect by that amount
            CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
            // Ask the overlay view to update just the changed area.
            [route_views[pos] setNeedsDisplayInMapRect:updateRect];
        }
        
    }
    //if(prev_line != [NSNull null])
    //    [self.mapView removeOverlay:prev_line];
    
    
    
    [route_lines replaceObjectAtIndex:pos withObject:prev_line];
    
    
}

- (void)locationManager:(RidingManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    int num= [self getUserNum:@"me"];
    [self addPoint:num withLocation:newLocation];
        
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


- (IBAction)setTrackUser:(id)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:true];
}

- (IBAction)setNoTrack:(id)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:false];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
    for(int i=0; i<[route_lines count]; ++i){
        if(overlay == [route_lines objectAtIndex:i]){
            MKPolylineView *view = [route_views objectAtIndex:i];
            
                if(view == [NSNull null])
                {
                    view = [[[CrumbPathView alloc] initWithOverlay:route_lines[i]] autorelease];
                    [view setColor:line_color[i]];
                    
                    [route_views replaceObjectAtIndex:i withObject:view];
                    //view.fillColor = [UIColor redColor];
                    //view.strokeColor = [UIColor redColor];
                    //view.lineWidth = 3;
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

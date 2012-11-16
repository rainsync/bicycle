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
        
        RidingManager *ridingManager =[RidingManager getInstance];
         [ridingManager addTarget:self];
        
        [self getUserNum:@"me"];

        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isHeading = FALSE;
    [self setHeading:self];
//    [self setTrackUser:self];
    
    
    RidingManager *ridingManager =[RidingManager getInstance];
    
    if([ridingManager isRiding]){
    
    }
    
   
    
    

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
        [route_lines replaceObjectAtIndex:pos withObject:prev_line];
        
        NSLog(@"changed..");
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
        [_mapView setRegion:region animated:YES];
        
    }else{
    
        MKMapRect updateRect = [prev_line addCoordinate:newLocation.coordinate];
        NSLog(@"%lf %lf %lf %lf %p %p gg", updateRect.origin.x, updateRect.origin.y, updateRect.size.height,updateRect.size.width, route_views[pos], [NSNull null]);
        
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
            MKCoordinateRegion region=_mapView.region;
            region.center = newLocation.coordinate;
            [_mapView setRegion:region animated:YES];
        }
        
    }
    

    //if(prev_line != [NSNull null])
    //    [self.mapView removeOverlay:prev_line];
    
    
    
    //[route_lines replaceObjectAtIndex:pos withObject:prev_line];
    
    
}

- (void)locationManager:(RidingManager *)manager
{
    

    int num= [self getUserNum:@"me"];
    [self addPoint:num withLocation:[manager current_location]];
    
        
}


- (void) RidingStopped
{
    int num=[self getUserNum:@"me"];
    
    [users removeObjectAtIndex:num];
    [route_views removeObjectAtIndex:num];
    [route_lines removeObjectAtIndex:num];
    [_mapView removeOverlays:_mapView.overlays];
    
    
}



- (IBAction)changeMap:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"일반 지도", @"위성 지도", @"일반 + 위성 지도", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

- (IBAction)setHeading:(id)sender {
    if(isHeading) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:false];
        isHeading = FALSE;
    }
    else {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:true];
        isHeading = TRUE;
    }
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
    _mapView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [_mapView release];
    [super dealloc];
}

@end

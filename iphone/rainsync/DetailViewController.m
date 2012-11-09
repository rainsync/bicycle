//
//  DetailViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 11. 6..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        view = [NSNull null];
        // Custom initialization
    }
    return self;
}


-(void)setMapCenter:(CLLocationCoordinate2D)location
{
    //[self.mapView setCenterCoordinate:location zoomLevel:13 animated:YES];
    
    
    NSLog(@"Current Location : %f, %f",location.latitude,location.longitude);
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.01;
    span.longitudeDelta=0.01;
    region.span=span;
    //location.latitude=(float *)(self.appDelegate.currentLocationLatitude);
    //location.latitude=self.appDelegate.currentLocationLongitude;
    region.center=location;
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    
    
    
}
- (void)loadView:(NSMutableDictionary *)rowData
{
    self.recordingDay.text = [rowData objectForKey:@"day"];
    self.recordingTime.text = [rowData objectForKey:@"time"];
    self.distance.text = [rowData objectForKey:@"distance"];
    self.averageSpeed.text = [rowData objectForKey:@"speed"];
    self.altitude.text = [rowData objectForKey:@"altitude"];
    self.calorie.text = [rowData objectForKey:@"calorie"];
    
    NSMutableArray * locations = [rowData objectForKey:@"locations"];
    CLLocationCoordinate2D * coords = malloc([locations count]*sizeof(MKMapPoint));
    
    int i=0;
    CLLocationCoordinate2D point;
    CLLocationCoordinate2D mid;
    //CLLocationCoordinate2D northEastPoint;
    //CLLocationCoordinate2D southWestPoint;
    
    for (CLLocation *location in locations) {
        point = location.coordinate;
        if(i==0)
            mid=point;
        coords[i++] = point;
        //point = MKMapPointForCoordinate(location.coordinate);

        
        //coords[i++]= point;

            
    }
    
    line = [MKPolyline polylineWithCoordinates:coords count:[locations count]];
    [self.mapView addOverlay:line];
    //point.latitude /= [locations count];
    //point.longitude /= [locations count];
    [self setMapCenter:mid];
    
    //MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    
    free(coords);
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_recordingDay release];
    [_recordingTime release];
    [_distance release];
    [_altitude release];
    [_averageSpeed release];
    [_calorie release];
    [_mapView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setRecordingDay:nil];
    [self setRecordingTime:nil];
    [self setDistance:nil];
    [self setAverageSpeed:nil];
    [self setAltitude:nil];
    [self setCalorie:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
    if(overlay == line){
        if(view == [NSNull null])
        {
            view = [[MKPolylineView alloc] initWithPolyline:line];
            view.fillColor = [UIColor redColor];
            view.strokeColor = [UIColor redColor];
            view.lineWidth = 3;
        }
        overlayView = view;
    }

    return overlayView;
    
}

@end

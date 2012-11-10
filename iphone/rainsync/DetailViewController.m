//
//  DetailViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 11. 6..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    _day = [rowData objectForKey:@"day"];
    _rectime = [rowData objectForKey:@"time"];
    _dist = [rowData objectForKey:@"distance"];
    _avgs = [rowData objectForKey:@"speed"];
    _altit = [rowData objectForKey:@"altitude"];
    _calo = [rowData objectForKey:@"calorie"];
    
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
    
    routeLine = [MKPolyline polylineWithCoordinates:coords count:[locations count]];
    [self.mapView addOverlay:routeLine];
//    //point.latitude /= [locations count];
//    //point.longitude /= [locations count];
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
    [_mapView release];
    [_detailTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMapView:nil];
    [self setDetailTableView:nil];
    [super viewDidUnload];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
    if(overlay == routeLine){
        if(view == [NSNull null])
        {
            view = [[MKPolylineView alloc] initWithPolyline:routeLine];
            view.fillColor = [UIColor redColor];
            view.strokeColor = [UIColor redColor];
            view.lineWidth = 3;
        }
        overlayView = view;
    }

    return overlayView;
    
}

#pragma mark -
#pragma mark Tableview Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *counts;
    counts = [NSArray arrayWithObjects:
              [NSNumber numberWithInt:1],  //map
              [NSNumber numberWithInt:6],  //location
              nil];
    
    return [[counts objectAtIndex:section] integerValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titles;
    titles = [NSArray arrayWithObjects:
              @"",                                      //map
              @"기록",               //location
              nil];
    
    return [titles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    switch (section)
    {
        case 0: return [self cellForMapView];
        case 1: return [self cellForLocationIndex:indexPath.row];
    }
    
    return nil;
}

#pragma mark -
#pragma mark Tableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 240.0f;
    }
    return [_detailTableView rowHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if its the map url cell, open the location in Google maps
    //
//    if (indexPath.section == 4) // map url is always last section
//    {
//        NSString *ll = [NSString stringWithFormat:@"%f,%f",
//                        self.placemark.location.coordinate.latitude,
//                        self.placemark.location.coordinate.longitude];
//        ll = [ll stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?ll=%@",ll];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//        
//        [_detailTableView deselectRowAtIndexPath:indexPath animated:NO];
//    }
}

#pragma mark - cell generators

- (UITableViewCell *)blankCell
{
    NSString *cellID = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)cellForLocationIndex:(NSInteger)index
{
    NSArray const *keys = [NSArray arrayWithObjects:
                           @"날짜",
                           @"주행 시간",
                           @"주행 거리",
                           @"평균 속도",
                           @"고도",
                           @"칼로리",
                           nil];
    
    if (index >= [keys count])
        index = [keys count] - 1;
    
    UITableViewCell *cell = [self blankCell];
    
    // setup
    NSString *key = [keys objectAtIndex:index];
    NSString *ivar = @"";
    
    // look up the values, special case lat and long and timestamp but first, special case placemark being nil.
//    if (self.placemark.location == nil)
//    {
//        ivar = @"location is nil.";
//    }
    if ([key isEqualToString:@"날짜"])
    {
        ivar = _day;
    }
    else if ([key isEqualToString:@"주행 시간"])
    {
        ivar = _rectime;
    }
    else if ([key isEqualToString:@"주행 거리"])
    {
        ivar = _dist;
    }
    else if ([key isEqualToString:@"평균 속도"])
    {
        ivar = _avgs;
    }
    else if ([key isEqualToString:@"고도"])
    {
        ivar = _altit;
    }
    else if ([key isEqualToString:@"칼로리"])
    {
        ivar = _calo;
    }
//    else
//    {
//        double var = [self doubleForObject:self.placemark.location andSelector:NSSelectorFromString(key)];
//        ivar = [self displayStringForDouble:var];
//    }
    
    // set cell attributes
    cell.textLabel.text = key;
    cell.detailTextLabel.text = ivar;
    
    return cell;
}

- (UITableViewCell *)cellForMapView
{
    if (_mapCell)
        return _mapCell;
    
    // if not cached, setup the map view...
    CGFloat cellWidth = self.view.bounds.size.width - 20;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cellWidth = self.view.bounds.size.width - 90;
    }
    
    CGRect frame = CGRectMake(0, 0, cellWidth, 240);
    _mapView = [[MKMapView alloc] initWithFrame:frame];
//    MKCoordinateRegion region =  MKCoordinateRegionMakeWithDistance(self.placemark.location.coordinate, 200, 200);
//    [map setRegion:region];
        
    _mapView.layer.masksToBounds = YES;
    _mapView.layer.cornerRadius = 10.0;
    _mapView.mapType = MKMapTypeStandard;
    [_mapView setScrollEnabled:NO];
    
    // add a pin using self as the object implementing the MKAnnotation protocol
//    [map addAnnotation:self];
    
    NSString * cellID = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
    
    [cell.contentView addSubview:_mapView];
//    [map release];
    
    _mapCell = [cell retain];
    return cell;
}

@end

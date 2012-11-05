//
//  DashBoardViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "DashBoardViewController.h"

@interface DashBoardViewController ()

@end

@implementation DashBoardViewController

@synthesize speedLabel, latitudeLabel, longitudeLabel, altitudeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


        // Custom initialization
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *location = newLocation;
    
        speedLabel.text = [NSString stringWithFormat:@"SPEED: %f", location.speed];
        latitudeLabel.text = [NSString stringWithFormat:@"LATITUDE: %f", location.coordinate.latitude];
        longitudeLabel.text = [NSString stringWithFormat:@"LONGITUDE: %f", location.coordinate.longitude];
        altitudeLabel.text = [NSString stringWithFormat:@"ALTITUDE: %f", location.altitude];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    RidingManager *ridingManager = [RidingManager getInstance];
    [ridingManager addTarget:self];
    [ridingManager startRiding];
    // Do any additional setup after loading the view from its nib.
    

}


- (void)locationUpdate:(CLLocation *)location {

}

- (void)locationError:(NSError *)error {
	speedLabel.text = [error description];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}



- (void)dealloc {
    [speedLabel release];
    [latitudeLabel release];
    [longitudeLabel release];
    [altitudeLabel release];
    [super dealloc];
}
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

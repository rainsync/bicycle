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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CLController = [[CoreLocationController alloc] init];
	CLController.delegate = self;
	[CLController.locMgr startUpdatingLocation];
     
}


- (void)locationUpdate:(CLLocation *)location {
	speedLabel.text = [NSString stringWithFormat:@"SPEED: %f", [location speed]];
	latitudeLabel.text = [NSString stringWithFormat:@"LATITUDE: %f", location.coordinate.latitude];
	longitudeLabel.text = [NSString stringWithFormat:@"LONGITUDE: %f", location.coordinate.longitude];
	altitudeLabel.text = [NSString stringWithFormat:@"ALTITUDE: %f", [location altitude]];
}

- (void)locationError:(NSError *)error {
	speedLabel.text = [error description];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}



- (void)dealloc {
	[CLController release];
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

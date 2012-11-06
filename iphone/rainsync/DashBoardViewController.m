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

@synthesize speedLabel, avgLabel, timeLabel, calorieLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


        // Custom initialization
    }
    return self;
}

- (void)locationManager:(RidingManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *location = newLocation;
    
    
    speedLabel.text = [NSString stringWithFormat:@"현재속도: %f", location.speed];
    avgLabel.text = [NSString stringWithFormat:@"평균속도: %f", [manager avgSpeed]];
    timeLabel.text = [NSString stringWithFormat:@"시간: %lf", [manager time]];
    double weight = 50;
    
    calorieLabel.text = [NSString stringWithFormat:@"칼로리: %lf", weight * [self calculateCalorie:[manager avgSpeed] ] * ([manager time]/60.0)];
    
}



- (float)calculateCalorie:(float)avgSpd {
    float kcalConstant = 0.0f;
    if (avgSpd <=1){
        kcalConstant = 0;
    }
    else if (avgSpd <= 13) {
        kcalConstant = 0.065f;
    }
    else if (avgSpd <= 16) {
        kcalConstant = 0.0783f;
    }
    else if (avgSpd <= 19) {
        kcalConstant = 0.0939f;
    }
    else if (avgSpd <= 22) {
        kcalConstant = 0.113f;
    }
    else if (avgSpd <= 24) {
        kcalConstant = 0.124f;
    }
    else if (avgSpd <= 26) {
        kcalConstant = 0.136f;
    }
    else if (avgSpd <= 27) {
        kcalConstant = 0.149f;
    }
    else if (avgSpd <= 29) {
        kcalConstant = 0.163f;
    }
    else if (avgSpd <= 31) {
        kcalConstant = 0.179f;
    }
    else if (avgSpd <= 32) {
        kcalConstant = 0.196f;
    }
    else if (avgSpd <= 34) {
        kcalConstant = 0.215f;
    }
    else if (avgSpd <= 37) {
        kcalConstant = 0.259f;
    }
    else {  // avgSpeed 40km/h 이상
        kcalConstant = 0.311f;
    }
    
    return kcalConstant;
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





- (void)dealloc {
    [speedLabel release];
    [avgLabel release];
    [timeLabel release];
    [calorieLabel release];
    [super dealloc];
}
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCalorieLabel:nil];
    [super viewDidUnload];
}
@end

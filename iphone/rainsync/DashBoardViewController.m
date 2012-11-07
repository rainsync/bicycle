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

        RidingManager *ridingManager = [RidingManager getInstance];
        [ridingManager addTarget:self];
        if([ridingManager isRiding])
            [ridingManager startRiding];
        paused =false;
        
        // Custom initialization
    }
    return self;
}

- (void)locationManager:(RidingManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *location = newLocation;
    
    
    speedLabel.text = [NSString stringWithFormat:@"%f", location.speed];
    avgLabel.text = [NSString stringWithFormat:@"%f", [manager avgSpeed]];
    timeLabel.text = [NSString stringWithFormat:@"%lf", [manager time]];
    double weight = 50;
    
    calorieLabel.text = [NSString stringWithFormat:@"%lf", weight * [self calculateCalorie:[manager avgSpeed] ] * ([manager time]/60.0)];
    
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

- (IBAction)starRiding:(id)sender {
    RidingManager *ridingManager = [RidingManager getInstance];
    [ridingManager startRiding];
    [self viewDidAppear:false];
}

- (IBAction)stopRiding:(id)sender {
    RidingManager *ridingManager = [RidingManager getInstance];
    [ridingManager stopRiding];
    [self viewDidAppear:false];
    
}

- (IBAction)pauseRiding:(id)sender {
    RidingManager *ridingManager = [RidingManager getInstance];
    
    if(paused){
    paused=false;
    [self.pauseButton setImage:[UIImage imageNamed:@"Button Pause"] forState:UIControlStateNormal];
    [ridingManager startRiding];
        
    }else{
    
    [ridingManager pauseRiding];
    [self viewDidAppear:false];
    paused =true;
    [self.pauseButton setImage:[UIImage imageNamed:@"Button Play"] forState:UIControlStateNormal];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    

}

- (void) viewDidAppear:(BOOL)animated
{
    RidingManager *ridingManager = [RidingManager getInstance];
    if([ridingManager isRiding]){
        [self.stopButton setHidden:false];
        [self.startButton setHidden:true];
        [self.pauseButton setHidden:false];
    }else{
        [self.stopButton setHidden:true];
        [self.startButton setHidden:false];
        [self.pauseButton setHidden:true];
    }
    
}




- (void)dealloc {
    [speedLabel release];
    [avgLabel release];
    [timeLabel release];
    [calorieLabel release];
    [_stopButton release];
    [_pauseButton release];
    [_startButton release];
    [_stopButton release];
    [_pauseButton release];
    [super dealloc];
}
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCalorieLabel:nil];
    [self setStopButton:nil];
    [self setPauseButton:nil];
    [self setStartButton:nil];
    [self setStopButton:nil];
    [self setPauseButton:nil];
    [self setPlayButton:nil];
    [super viewDidUnload];
}
@end

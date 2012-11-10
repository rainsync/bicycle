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

@synthesize speedLabel, avgLabel, timeLabel, calorieLabel, distanceLabel;

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
    
    if(location.speed == -1)
    speedLabel.text = @"00.0";
    else
    speedLabel.text = [NSString stringWithFormat:@"%.2f", location.speed * 3.6];
    
    avgLabel.text = [NSString stringWithFormat:@"%.2f", [manager avgSpeed]];

    double weight = 50;
    
    calorieLabel.text = [NSString stringWithFormat:@"%0.2lf", weight * [self calculateCalorie:[manager avgSpeed] ] * ([manager time]/60.0)];
    distanceLabel.text = [NSString stringWithFormat:@"%0.2lf", [manager totalDistance]/1000.0f];
    
    
}

- (void)updateTime:(double)time
{
    int i_time = (int)time;
    int sec = i_time%60;
    int min = i_time/60%60;
    int hour = i_time/60/60%24;
    
    
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];

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
//    [self viewDidAppear:false];
    
    [self.stopButton setHidden:YES];
    [self.stopSwitch setHidden:YES];
    [self.stopLabel setHidden:YES];
    [self.startButton setHidden:YES];
    [self.pauseButton setHidden:NO];
    [self.statusLabel setText:@"정지"];
}

- (IBAction)stopRiding:(id)sender {
    paused = false;
    
    RidingManager *ridingManager = [RidingManager getInstance];
    [ridingManager stopRiding];
//    [self viewDidAppear:false];
    
    timeLabel.text = @"00:00:00";
    speedLabel.text = @"00.0";
    distanceLabel.text = @"0.00";
    avgLabel.text = @"00.0";
    speedLabel.text = @"00.0";
    calorieLabel.text = @"0.00";
    
    [self.stopButton setHidden:YES];
    [self.stopSwitch setHidden:YES];
    [self.stopLabel setHidden:YES];
    [self.startButton setHidden:NO];
    [self.pauseButton setHidden:YES];
    [self.statusLabel setText:@"시작"];
}

- (IBAction)pauseRiding:(id)sender {
    RidingManager *ridingManager = [RidingManager getInstance];
    
    if(paused) {
        paused = false;
        [ridingManager startRiding];
        [self.stopButton setHidden:YES];
        [self.stopSwitch setHidden:YES];
        [self.stopLabel setHidden:YES];
        [self.startButton setHidden:YES];
        [self.pauseButton setHidden:NO];
        [self.statusLabel setText:@"정지"];
    }
    else {
        paused =true;
        [ridingManager pauseRiding];
        [self.stopButton setHidden:NO];
        [self.stopSwitch setHidden:NO];
        [self.stopLabel setHidden:NO];
        [self.startButton setHidden:NO];
        [self.pauseButton setHidden:YES];
        [self.statusLabel setText:@"주행"];
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
        [self.stopButton setHidden:YES];
        [self.stopSwitch setHidden:YES];
        [self.stopLabel setHidden:YES];
        [self.startButton setHidden:YES];
        [self.pauseButton setHidden:NO];
        [self.statusLabel setText:@"정지"];
    }else{
        [self.stopButton setHidden:NO];
        [self.stopSwitch setHidden:NO];
        [self.stopLabel setHidden:NO];
        [self.startButton setHidden:NO];
        [self.pauseButton setHidden:YES];
        [self.statusLabel setText:@"주행"];
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
    [distanceLabel release];
    [_stopSwitch release];
    [_stopLabel release];
    [_statusLabel release];
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
    [self setDistanceLabel:nil];
    [self setStopSwitch:nil];
    [self setStopLabel:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
}
@end

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
    
    avgLabel.text = [NSString stringWithFormat:@"%.2f", [Utility mpsTokph:[manager totalDistance]  WithTime:[manager time]]];

    
    //calorieLabel.text = [NSString stringWithFormat:@"%0.2lf", weight * [self calculateCalorie:[manager avgSpeed] ] * ([manager time]/60.0)];
    
    calorieLabel.text = [NSString stringWithFormat:@"%d", [manager calorie] ];
    
    distanceLabel.text = [NSString stringWithFormat:@"%0.2lf", [manager totalDistance]/1000.0f];
    
    
}

- (void)updateTime:(RidingManager*)manager
{

    timeLabel.text = [Utility getStringTime:[manager time]];
    
}






- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
    
}



- (IBAction)stopRiding:(id)sender {
    paused = false;
    [self.statusButton setImage:[UIImage imageNamed:@"startSingleRiding"] forState:UIControlStateNormal];
    
    RidingManager *ridingManager = [RidingManager getInstance];
    [ridingManager stopRiding];
    timeLabel.text = @"00:00:00";
    speedLabel.text = @"00.0";
    distanceLabel.text = @"0.00";
    avgLabel.text = @"00.0";
    speedLabel.text = @"00.0";
    calorieLabel.text = @"0.00";
    [self.stopButton setHidden:true];
    
    
    
}

- (IBAction)statusChanged:(id)sender {
    RidingManager *ridingManager = [RidingManager getInstance];
    
    if(!paused){
        paused=true;
        [self.statusButton setImage:[UIImage imageNamed:@"pauseSingleRiding"] forState:UIControlStateNormal];
        [ridingManager loadStatus];
        [ridingManager startRiding];
        [self.stopButton setHidden:false];
        
    }else{
        
        [ridingManager pauseRiding];
        
        paused =false;
        [self.statusButton setImage:[UIImage imageNamed:@"startSingleRiding"] forState:UIControlStateNormal];
        
        [self.stopButton setHidden:true];
        
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

    
    [ridingManager addTarget:self];
    if([ridingManager isRiding]){
        UIAlertView *view=[[UIAlertView alloc] initWithTitle:@"알림" message:@"이전 라이딩을 불러오시겠습니까?"  delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"네", nil];
        [view show];
        [view release];
        
    }
    
    paused = false;

    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    RidingManager *ridingManager = [RidingManager getInstance];
    switch (buttonIndex) {
        case 0:
        {
            [ridingManager discardStatus];
        }
        case 1:
        {
            [ridingManager loadStatus];
            

            speedLabel.text = @"00.0";

            avgLabel.text = [NSString stringWithFormat:@"%.2f", [Utility mpsTokph:[ridingManager totalDistance]  WithTime:[ridingManager time]] ];
            
            
            calorieLabel.text = [NSString stringWithFormat:@"%0.2lf",[ridingManager calorie]];
            distanceLabel.text = [NSString stringWithFormat:@"%0.2lf", [ridingManager totalDistance]/1000.0f];
            
            [self updateTime:ridingManager];
            
            
            
        }
    }
    
    
    
}


- (void)dealloc {
    [speedLabel release];
    [avgLabel release];
    [timeLabel release];
    [calorieLabel release];
    [_stopButton release];
    [_statusButton release];
    [distanceLabel release];
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
    [self setStatusButton:nil];
    [self setStopButton:nil];
    [self setDistanceLabel:nil];
    [super viewDidUnload];
}
@end

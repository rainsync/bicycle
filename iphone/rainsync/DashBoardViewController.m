//
//  DashBoardViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "DashBoardViewController.h"
#import "GroupRideViewController.h"
#import "PrettyKit.h"

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




- (void)locationManager:(RidingManager *)manager
{
    

    
    if([manager current_location].speed == -1)
        speedLabel.text = @"00.0";
    else
        speedLabel.text = [NSString stringWithFormat:@"%.2lf", [Utility mpsTokph:[manager current_location].speed]];
    
    avgLabel.text = [NSString stringWithFormat:@"%.2lf", [Utility mpsTokph:[manager avgSpeed]]];

    calorieLabel.text = [NSString stringWithFormat:@"%.2lf", [manager calorie] ];
    
    distanceLabel.text = [NSString stringWithFormat:@"%.2lf", [Utility metreTokilometre:[manager totalDistance]]];
    
    
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
    [self.stopButton setEnabled:NO];
    [self.stopLabel setAlpha:0.5f];
    
    
}

- (IBAction)statusChanged:(id)sender {
    RidingManager *ridingManager = [RidingManager getInstance];
    
    NSLog(@"%d", [ridingManager isRiding]);
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"RidingType"]);
    if(![ridingManager isRiding] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"RidingType"] isEqualToString:@"Group"]) {    // 시작 전이고 싱글라이딩이 아니라면
        GroupRideViewController *groupRideViewController = [[GroupRideViewController alloc] initWithNibName:@"GroupRideViewController" bundle:nil];
        [self presentModalViewController:groupRideViewController animated:YES];
        
        [groupRideViewController release];
    }
    else if(!paused){
        paused=true;
        [ridingManager loadStatus];
        [ridingManager startRiding];
        [self.statusButton setImage:[UIImage imageNamed:@"pause_SingleRiding"] forState:UIControlStateNormal];
        [self.statusLabel setText:@"멈추기"];
        [self.stopButton setEnabled:NO];
        [self.stopLabel setAlpha:0.5f];
        
    }else{
        
        [ridingManager pauseRiding];
        
        paused =false;
        [self.statusButton setImage:[UIImage imageNamed:@"startSingleRiding"] forState:UIControlStateNormal];
        [self.statusLabel setText:@"달리기"];
        [self.stopButton setEnabled:YES];
        [self.stopLabel setAlpha:1.0f];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Do any additional setup after loading the view from its nib.
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"RidingType"] isEqualToString:@"Single"]) {
        [_modeChangeButton setTitle:@"그룹모드로" forState:UIControlStateNormal];
    }
    else {
        [_modeChangeButton setTitle:@"싱글모드로" forState:UIControlStateNormal];
    }
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
    else {
        [_stopButton setEnabled:NO];    // 처음 시작이면 정지버튼 비활성
        [_stopLabel setAlpha:0.5f];
    }
    paused = false;

    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    RidingManager *ridingManager = [RidingManager getInstance];
    switch (buttonIndex) {
        case 0:
        {
            [ridingManager discardStatus];
//            [_stopButton setEnabled:NO];
//            [_stopLabel setAlpha:0.5f];
            break;
        }
        case 1:
        {
            [ridingManager loadStatus];
            [self locationManager:ridingManager];
            [self updateTime:ridingManager];
            break;
            
            
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
    [_statusLabel release];
    [_stopLabel release];
    [_modeChangeButton release];
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
    [self setStatusLabel:nil];
    [self setStopLabel:nil];
    [self setModeChangeButton:nil];
    [super viewDidUnload];
}

- (IBAction)modeChange:(id)sender {
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"RidingType"]);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"RidingType"] isEqualToString:@"Single"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Group" forKey:@"RidingType"];
        [_modeChangeButton setTitle:@"싱글모드로" forState:UIControlStateNormal];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"Single" forKey:@"RidingType"];
        [_modeChangeButton setTitle:@"그룹모드로" forState:UIControlStateNormal];
    }
}
@end

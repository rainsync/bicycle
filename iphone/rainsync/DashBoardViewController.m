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
        first=true;
        
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
    
    

    calorieLabel.text = [NSString stringWithFormat:@"%.2lf", [manager calorie] ];
    distanceLabel.text = [NSString stringWithFormat:@"%.2lf", [Utility metreTokilometre:[manager totalDistance]]];
    
    
    double cal = [manager calorie];
    double dist = [Utility metreTokilometre:[manager totalDistance]];
    double cspeed = [Utility mpsTokph:[manager current_location].speed];
    
    for (int i=0; i<10; i++) {
        if (i == (int)cal/100)
            _cal_100.image = [numberArray objectAtIndex:i];;
        if (i == (int)cal/10%10)
            _cal_10.image = [numberArray objectAtIndex:i];
        if (i == (int)cal%10)
            _cal_1.image = [numberArray objectAtIndex:i];
        
        if (i == (int)(dist*10)%10)    // 소수 첫째자리
            _dist_decimal.image = [numberArray objectAtIndex:i];
        if (i == (int)dist%10)
            _dist_1.image = [numberArray objectAtIndex:i];
        if (i == (int)dist/10%10)
            _dist_10.image = [numberArray objectAtIndex:i];
        if (i == (int)dist/100)
            _dist_100.image = [numberArray objectAtIndex:i];
        
        if (i == (int)(cspeed*10)%10)
            _curr_decimal.image = [numberArray objectAtIndex:i];
        if (i == (int)cspeed%10)
            _curr_1.image = [numberArray objectAtIndex:i];
        if (i == (int)cspeed/10%10)
            _curr_10.image = [numberArray objectAtIndex:i];
    }
}

- (void)updateTime:(RidingManager*)manager
{
    
    avgLabel.text = [NSString stringWithFormat:@"%.2lf", [Utility mpsTokph:[manager avgSpeed]]];
    timeLabel.text = [Utility getStringTime:[manager time]];
    
    double aspeed = [Utility mpsTokph:[manager avgSpeed]];
    int h = [Utility getTimeHour:[manager time]];
    int m = [Utility getTimeMinute:[manager time]];
    int s = [Utility getTimeSecond:[manager time]];

    for (int i=0; i<10; i++) {
        if (i==h/10)
            _time_hour10.image = [numberArray objectAtIndex:i];
        if (i==h%10)
            _time_hour1.image = [numberArray objectAtIndex:i];
        if (i==m/10)
            _time_minute10.image = [numberArray objectAtIndex:i];
        if (i==m%10)
            _time_minute1.image = [numberArray objectAtIndex:i];
        if (i==s/10)
            _time_second10.image = [numberArray objectAtIndex:i];
        if (i==s%10)
            _time_second1.image = [numberArray objectAtIndex:i];
        
        if (i == (int)(aspeed*10)%10)
            _avg_decimal.image = [numberArray objectAtIndex:i];
        if (i == (int)aspeed%10)
            _avg_1.image = [numberArray objectAtIndex:i];
        if (i == (int)aspeed/10%10)
            _avg_10.image = [numberArray objectAtIndex:i]; 
    }
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
        //[self presentModalViewController:groupRideViewController animated:YES];
        [self.parentViewController.navigationController pushViewController:groupRideViewController animated:YES];
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
    
    numberArray = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d.png", i] ofType:nil];
        UIImage *numberImage = [UIImage imageWithContentsOfFile:filePath];
        [numberArray addObject:numberImage];
    }   // 숫자 이미지 초기화


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
    if(first){
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
    first=false;
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    RidingManager *ridingManager = [RidingManager getInstance];
    [ridingManager loadStatus];
    switch (buttonIndex) {
        case 0:
        {
            [ridingManager stopRiding];
//            [_stopButton setEnabled:NO];
//            [_stopLabel setAlpha:0.5f];
            break;
        }
        case 1:
        {
            
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
    [_time_second1 release];
    [_time_second10 release];
    [_time_minute1 release];
    [_time_minute10 release];
    [_time_hour1 release];
    [_time_hour10 release];
    
    [numberArray release];
    [_dist_decimal release];
    [_dist_1 release];
    [_dist_10 release];
    [_dist_100 release];
    [_avg_decimal release];
    [_avg_1 release];
    [_avg_10 release];
    [_curr_decimal release];
    [_curr_1 release];
    [_curr_10 release];
    [_cal_1 release];
    [_cal_10 release];
    [_cal_100 release];
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
    [self setTime_second1:nil];
    [self setTime_second10:nil];
    [self setTime_minute1:nil];
    [self setTime_minute10:nil];
    [self setTime_hour1:nil];
    [self setTime_hour10:nil];
    
    numberArray = nil;
    [self setDist_decimal:nil];
    [self setDist_1:nil];
    [self setDist_10:nil];
    [self setDist_100:nil];
    [self setAvg_decimal:nil];
    [self setAvg_1:nil];
    [self setAvg_10:nil];
    [self setCurr_decimal:nil];
    [self setCurr_1:nil];
    [self setCurr_10:nil];
    [self setCal_1:nil];
    [self setCal_10:nil];
    [self setCal_100:nil];
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

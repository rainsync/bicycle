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
        //0
        
        
        group_ride_mode=0;
        net = [self.tabBarController getNetUtility];
        ridingManager=[self.tabBarController getRidingManager];
        
        // Custom initialization
    }
    return self;
}





- (void)locationManager:(RidingManager *)manager
{
    

    
    if([manager current_location].speed == -1)
        speedLabel.image = [Utility numberImagify:@"0.0"];
    else
        speedLabel.image = [Utility numberImagify:[NSString stringWithFormat:@"%.1lf", [Utility mpsTokph:[manager current_location].speed]]];
    
    

    calorieLabel.image = [Utility numberImagify:[NSString stringWithFormat:@"%.1lf", [manager calorie] ]];
    distanceLabel.image = [Utility numberImagify:[NSString stringWithFormat:@"%.1lf", [Utility metreTokilometre:[manager totalDistance]]]];
    
    
    calorieLabel.image = [Utility numberImagify:[NSString stringWithFormat:@"%.1lf", [manager calorie] ]];
    distanceLabel.image = [Utility numberImagify:[NSString stringWithFormat:@"%.1lf", [Utility metreTokilometre:[manager totalDistance]]]];
    

}

- (void)updateTime:(RidingManager*)manager
{
    
    avgLabel.image = [Utility numberImagify:[NSString stringWithFormat:@"%.1lf", [Utility mpsTokph:[manager avgSpeed]]]];
    timeLabel.image = [Utility numberImagify:[Utility getStringTime:[manager time]]];
    

}






- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
    
}



- (IBAction)stopRiding:(id)sender {
    paused = false;
    [self.statusButton setImage:[UIImage imageNamed:@"startSingleRiding"] forState:UIControlStateNormal];
    
    [ridingManager stopRiding];
    timeLabel.image = [Utility numberImagify:@"00:00:00"];
    speedLabel.image = [Utility numberImagify:@"0.0"];
    distanceLabel.image = [Utility numberImagify:@"0.0"];
    avgLabel.image = [Utility numberImagify:@"0.0"];
    speedLabel.image = [Utility numberImagify:@"0.0"];
    calorieLabel.image = [Utility numberImagify:@"0.0"];
    [self.stopButton setEnabled:NO];
    [self.stopLabel setAlpha:0.5f];
    
    [self.modeChangeButton setEnabled:YES];
    [self.modeChangeLabel setEnabled:1.0f];
}

- (IBAction)statusChanged:(id)sender {

    NSLog(@"%d", [ridingManager isRiding]);
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"RidingType"]);
    
    if(![ridingManager isRiding] && [ridingManager ridingType]==1) {    // 시작 전이고 싱글라이딩이 아니라면

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        hud.dimBackground=TRUE;
        [hud show:TRUE];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"RidingType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [net raceInfoWithblock:^(NSDictionary *res, NSError *error) {
            if(error){
                UIAlertView *view= [[UIAlertView alloc] initWithTitle:@"ERROR" message:error.description delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [view show];
                [view release];
            }else{
                
                NSInteger state=[[res objectForKey:@"state"] intValue];
                NSMutableArray *participants=[res objectForKey:@"participants"];
                
                
                if(state==0){
                    if([participants count]==0){
                        //no one? thne invite!
                        group_ride_mode=1;
                        GroupRideViewController *groupRideViewController = [GroupRideViewController alloc];
                        
                        //[self presentModalViewController:groupRideViewController animated:YES];
                        [self.navigationController pushViewController:groupRideViewController animated:NO];
                        [groupRideViewController initWithNibName:@"GroupRideViewController" bundle:nil];
                        [groupRideViewController release];
                        
                    }else{
                        //[self.parentViewController setPage:2];
                        //[[self.parentViewController.childViewControllers objectAtIndex:2] ShowMember:participants];
                        group_ride_mode=2;
                        [ridingManager loadStatus];
                        [ridingManager startRiding];
                    }
                    
                    
                }else{
                    group_ride_mode=0;
                }
                [hud hide:TRUE];

            }
        }];
           }
    if(!paused){
        if([ridingManager ridingType]==0)
        {
        paused=true;
        [ridingManager loadStatus];
        [ridingManager startRiding];
        [self.statusButton setImage:[UIImage imageNamed:@"pauseSingleRiding"] forState:UIControlStateNormal];
        [self.statusLabel setText:@"멈추기"];
        [self.stopButton setEnabled:NO];
        [self.stopLabel setAlpha:0.5f];
            [self.modeChangeButton setEnabled:NO];
            [self.modeChangeLabel setAlpha:0.5f];
        }else{
            
            
            
        }
    }else{
        
        [ridingManager pauseRiding];
        
        paused =false;
        [self.statusButton setImage:[UIImage imageNamed:@"startSingleRiding"] forState:UIControlStateNormal];
        [self.statusLabel setText:@"달리기"];
        [self.stopButton setEnabled:YES];
        [self.stopLabel setAlpha:1.0f];

        if (![ridingManager isRiding]) { // 일시정지지만 라이딩을 시작 안했을때만 모드 변경 가능
            [self.modeChangeButton setEnabled:YES];
            [self.modeChangeLabel setEnabled:1.0f];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
NSInteger type = [ridingManager ridingType];

    if (type==0) {
       [_modeLabel setText:@"Single Riding"];
        [_stopButton setImage:[UIImage imageNamed:@"stopSingleRiding"] forState:UIControlStateNormal];
        [_statusButton setImage:[UIImage imageNamed:@"startSingleRiding"] forState:UIControlStateNormal];        
    }
    else if(type==1){
        [_modeLabel setText:@"Group Riding"];
        [_stopButton setImage:[UIImage imageNamed:@"stopGroupRiding"] forState:UIControlStateNormal];
        [_statusButton setImage:[UIImage imageNamed:@"startGroupRiding"] forState:UIControlStateNormal];
        
        CABasicAnimation* rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation2.removedOnCompletion = NO;
        rotationAnimation2.fillMode = kCAFillModeForwards;
        rotationAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnimation2.delegate = self;
        rotationAnimation2.fromValue = [NSNumber numberWithInt:0];
        rotationAnimation2.toValue = [NSNumber numberWithFloat:M_PI_2];//(1 * M_PI) * direction];
        rotationAnimation2.duration = 0.5f;
        [_modeChangeButton.imageView addAnimation:rotationAnimation2 forKey:@"rotateAnimation"];
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{

    
    if(first){
        timeLabel.image = [Utility numberImagify:@"00:00:00"];
        speedLabel.image = [Utility numberImagify:@"0.0"];
        distanceLabel.image = [Utility numberImagify:@"0.0"];
        avgLabel.image = [Utility numberImagify:@"0.0"];
        speedLabel.image = [Utility numberImagify:@"0.0"];
        calorieLabel.image = [Utility numberImagify:@"0.0"];
        

    
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
    [_modeLabel release];
    [_bottom_dashboard release];
    [_modeChangeLabel release];
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

    [self setTest:nil];
    [self setModeLabel:nil];
    [self setBottom_dashboard:nil];
    [self setModeChangeLabel:nil];
    [super viewDidUnload];
}

- (IBAction)modeChange:(id)sender {

    NSInteger type = [ridingManager ridingType];
        
    CABasicAnimation* rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.removedOnCompletion = NO;
    rotationAnimation2.fillMode = kCAFillModeForwards;
    rotationAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation2.delegate = self;
    
    if (type==0) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"RidingType"];
//        [_modeChangeButton setTitle:@"싱글모드로" forState:UIControlStateNormal];
        [_stopButton setImage:[UIImage imageNamed:@"stopGroupRiding"] forState:UIControlStateNormal];
        [_statusButton setImage:[UIImage imageNamed:@"startGroupRiding"] forState:UIControlStateNormal];
        [_modeLabel setText:@"Group Riding"];
        
        rotationAnimation2.fromValue = [NSNumber numberWithInt:0];
        rotationAnimation2.toValue = [NSNumber numberWithFloat:M_PI_2];//(1 * M_PI) * direction];
        rotationAnimation2.duration = 0.5f;
        [_modeChangeButton.imageView addAnimation:rotationAnimation2 forKey:@"rotateAnimation"];
    }
    else if(type==1)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"RidingType"];
//        [_modeChangeButton setTitle:@"그룹모드로" forState:UIControlStateNormal];
        [_stopButton setImage:[UIImage imageNamed:@"stopSingleRiding"] forState:UIControlStateNormal];
        [_statusButton setImage:[UIImage imageNamed:@"singleStartRiding"] forState:UIControlStateNormal];
        [_modeLabel setText:@"Single Riding"];
        
        rotationAnimation2.fromValue = [NSNumber numberWithFloat:M_PI_2];
        rotationAnimation2.toValue = [NSNumber numberWithInt:0];//(1 * M_PI) * direction];
        rotationAnimation2.duration = 0.5f;
        [_modeChangeButton.imageView addAnimation:rotationAnimation2 forKey:@"rotateAnimation"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.parentViewController refreshPageControl];
    
}

@end

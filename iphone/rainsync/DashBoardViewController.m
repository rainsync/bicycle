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
        hud=nil;
        //0 
        group_ride_mode=0;
        [[NetUtility getInstance] addHandler:self];
        // Custom initialization
    }
    return self;
}


- (void) reqSuccess:(int)message withJSON:(NSDictionary *)dic {
    switch (message) {
        case race_info:
        {
            NSInteger state=[[dic objectForKey:@"state"] intValue];
            NSMutableArray *participants=[dic objectForKey:@"participants"];

            
            if(state==0){
                if([participants count]==0){
                        //no one? thne invite!
                    group_ride_mode=1;
                }else{
                    //invited? then ride start
                    group_ride_mode=2;
                }
                
                
            }else{
                NSError *error=[NSError errorWithDomain:@"잘못된 요청" code:state userInfo:nil];
                [self reqFail:error];
            }
            break;
            
        }
        default:
        {
            NSError *error=[NSError errorWithDomain:@"서버로 부터 잘못된 데이터가 전송되었습니다." code:-2 userInfo:nil];
            [self reqFail:error];
            break;
        }
    }
    
}

- (void)reqFail:(NSError*)error
{
    if(hud)
    [hud hide:TRUE];
    
    group_ride_mode=0;
    
    //[self showError:error];
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
    
    RidingManager *ridingManager = [RidingManager getInstance];
    [ridingManager stopRiding];
    timeLabel.image = [Utility numberImagify:@"00:00:00"];
    speedLabel.image = [Utility numberImagify:@"0.0"];
    distanceLabel.image = [Utility numberImagify:@"0.0"];
    avgLabel.image = [Utility numberImagify:@"0.0"];
    speedLabel.image = [Utility numberImagify:@"0.0"];
    calorieLabel.image = [Utility numberImagify:@"0.0"];
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
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        hud.delegate=self;
        hud.dimBackground=TRUE;
        [hud show:TRUE];
        NetUtility *net = [NetUtility getInstance];
        [net race_info];
        [net end];
        
        
    }
    if(!paused){
        if([ridingManager ridingType]==0)
        {
        paused=true;
        [ridingManager loadStatus];
        [ridingManager startRiding];
        [self.statusButton setImage:[UIImage imageNamed:@"pause_SingleRiding"] forState:UIControlStateNormal];
        [self.statusLabel setText:@"멈추기"];
        [self.stopButton setEnabled:NO];
        [self.stopLabel setAlpha:0.5f];
            
        }else{
            
            
            
        }
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
    
NSInteger type = [[RidingManager getInstance] ridingType];

    if (type==0) {
        [_modeChangeButton setTitle:@"그룹모드로" forState:UIControlStateNormal];
       [_modeLabel setText:@"Single Riding"];
    }
    else if(type==1){
      [_modeChangeButton setTitle:@"싱글모드로" forState:UIControlStateNormal];
        [_modeLabel setText:@"Group Riding"];
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
    [_modeLabel release];
    [_bottom_dashboard release];
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
    [super viewDidUnload];
}

- (IBAction)modeChange:(id)sender {

    int direction = 1;//[sender tag] == ROTATE_LEFT_TAG ? -1 : 1;
	CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotationAnimation.toValue = [NSNumber numberWithFloat:(1 * M_PI) * direction];
	rotationAnimation.duration = 1.0f;
	rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[_bottom_dashboard addAnimation:rotationAnimation forKey:@"rotateAnimation"];
    _bottom_dashboard.transform = CGAffineTransformRotate(_bottom_dashboard.transform, 1 * M_PI);
    

    NSInteger type = [[RidingManager getInstance] ridingType];
    
    if (type==0) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"RidingType"];
        [_modeChangeButton setTitle:@"싱글모드로" forState:UIControlStateNormal];
        [_modeLabel setText:@"Group Riding"];

        
    }
    else if(type==1)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"RidingType"];
        [_modeChangeButton setTitle:@"그룹모드로" forState:UIControlStateNormal];
        [_modeLabel setText:@"Single Riding"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.parentViewController refreshPageControl];
}

- (void)hudWasHidden:(MBProgressHUD *)HUD {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}
@end

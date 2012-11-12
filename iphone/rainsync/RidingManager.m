//
//  LocationManager.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "RidingManager.h"
#import "RidingDB.h"

@implementation RidingManager




+(RidingManager*)getInstance
{
    static RidingManager* _instance = nil;
    if(_instance == nil)
    {
        @synchronized(self)
        {
            if(_instance == nil)
            {
                _instance = [[RidingManager alloc] init];
            }
        }
    }
    return _instance;
}

- (id)init
{
    
    locmanager = [[CLLocationManager alloc] init];
    locmanager.delegate = self;
    locations = [[NSMutableArray alloc] init];
    
    targets = [[NSMutableArray alloc] init];
    ridingDB = [[RidingDB alloc] init];
    return self;
}

//m/s
-(double)avgSpeed
{
    
    return _totalDistance/_time;
}


- (void)addTarget:(id)obj
{
    [targets addObject:obj];
}

- (void)loadStatus
{
    if([self isRiding])
    {
        //unexpectly exit case
        
        //load previous path
        
        
        
        
        //reInvoke previous path
        
        
        //[self locationManager:locmanager didUpdateLocations:locations];
        
        
        @try {
            oldt= [[NSDate date] timeIntervalSince1970];
            _totalDistance = [[NSUserDefaults standardUserDefaults] doubleForKey:@"distance"];
            _time = [[NSUserDefaults standardUserDefaults] doubleForKey:@"time"];
            _calorie = [[NSUserDefaults standardUserDefaults] doubleForKey:@"calorie"];
            _start_date = [[NSUserDefaults standardUserDefaults] doubleForKey:@"start_date"];
            if(_totalDistance==0 && _time ==0 && _calorie ==0 && _start_date==0)
                @throw [NSException exceptionWithName:@"Setting" reason:@"old data is not correct" userInfo:nil];
            
        }
        @catch (NSException *exception) {
            _totalDistance=0;
            _time =0;
            _calorie =0;
            _start_date =[[NSDate date] timeIntervalSince1970];
        }
        
        
    }else{
        
        
        
        _totalDistance=0;
        _time =0;
        _calorie = 0;
        _start_date = [[NSDate date] timeIntervalSince1970];
        
        locations = [[NSMutableArray alloc] init];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsRiding"];
        [[NSUserDefaults standardUserDefaults] setDouble:_time forKey:@"time"];
        [[NSUserDefaults standardUserDefaults] setDouble:_totalDistance forKey:@"distance"];
        [[NSUserDefaults standardUserDefaults] setDouble:_calorie forKey:@"calorie"];
        [[NSUserDefaults standardUserDefaults] setDouble:_start_date forKey:@"start_date"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }
    weight =50;
    
}

- (void)saveStatus
{
    [[NSUserDefaults standardUserDefaults] setDouble:_time forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setDouble:_totalDistance forKey:@"distance"];
    [[NSUserDefaults standardUserDefaults] setDouble:_calorie forKey:@"calorie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)discardStatus
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsRiding"];
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"distance"];
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"calorie"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



- (void)startRiding
{

        
    oldt=[[NSDate date] timeIntervalSince1970];
    //[locmanager set]
    [locmanager startUpdatingLocation];
    [locmanager startUpdatingHeading];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkTime:) userInfo:nil repeats:YES];

    
    
}


- (void)checkTime:(NSTimer *)timer {
    
    _time+=[[NSDate date] timeIntervalSince1970]-oldt;
    oldt=[[NSDate date] timeIntervalSince1970];
    
    [self saveStatus];
    
    [ridingDB saveLocation:locations];
    [locations removeAllObjects];
    
    
    
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(updateTime:)])
            [obj updateTime:self];
    }
}


- (void)stopRiding
{
    
    [locmanager stopUpdatingLocation];
    [locmanager stopUpdatingHeading];
    

    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(RidingStopped)])
            [obj RidingStopped];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"기록 측정 종료" message:@"저장하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"네넹", nil];
    [alertView show];
    [alertView release];
    
    
}



# pragma mark -
# pragma mark AlertView Delegate

// stopRiding이 모두 실행 된 다음에 이 메서드가 실행 된다.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [ridingDB discardRecording];
            NSLog(@"저장 취소");
            break;
        }
        case 1:
        {
            [ridingDB saveRecording:self];
            //[ridingDB saveRecordingTime:[NSString stringWithFormat:@"%f", time] withDistance:[NSString stringWithFormat:@"%f", _totalDistance] withAverageSpeed:[NSString stringWithFormat:@"%f", [self avgSpeed]] withlocation:locations withCalories:@"20"];
            // save database
            
            NSLog(@"저장 완료");

            break;
        }
    }
    
    
    [self discardStatus];
    

}

- (void)pauseRiding
{
    [self saveStatus];
    
    [locmanager stopUpdatingLocation];
    [locmanager stopUpdatingHeading];
    if(timer){
    [timer invalidate];
    timer = nil;
    }
    
}

- (BOOL)isRiding
{
   return [[NSUserDefaults standardUserDefaults] boolForKey:@"IsRiding"];

}





- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    _current_location=newLocation;
    
    
    
    [locations addObject:newLocation];
    
    if([newLocation speed])
    {
        if(_max_speed==0 && [newLocation speed] != -1)
            _max_speed = [newLocation speed];
        else if(_max_speed < [newLocation speed])
            _max_speed = [newLocation speed];
    }
    
    if(oldLocation){
        _totalDistance += [oldLocation distanceFromLocation:newLocation];
        if([oldLocation speed])
        _calorie += weight * (([[newLocation timestamp] timeIntervalSince1970]-[[oldLocation timestamp] timeIntervalSince1970])/60.0) * [Utility calculateCalorie:[oldLocation speed]*3.6];
        
    }

    
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(locationManager:)])
        [obj locationManager:self];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    switch (error.code) {
        case kCLErrorLocationUnknown:
            NSLog(@"can't get Location info");
            break;
            
        case kCLErrorDenied:
            NSLog(@"access denied");
            break;
    
        case kCLErrorHeadingFailure:
            NSLog(@"strong magnetic nearby");
        default:
            break;
    }

    /*
    for (id obj in targets){
        [obj locationManager:manager did];
    }
    */
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(locationManager:didUpdateHeading:)])
            [obj locationManager:self didUpdateHeading:newHeading];
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    
    
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    
}

@end

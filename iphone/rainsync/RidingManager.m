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
    
    return self;
}


- (NSMutableArray*)getlocations
{
    return locations;
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
            if(_totalDistance==0 && _time ==0 && _calorie ==0)
                @throw [NSException exceptionWithName:@"Setting" reason:@"old data is not correct" userInfo:nil];
            
        }
        @catch (NSException *exception) {
            _totalDistance=0;
            _time =0;
            _calorie =0;
        }
        
        
    }else{
        
        
        
        _totalDistance=0;
        _time =0;
        _calorie = 0;
    
        locations = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsRiding"];
        [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"time"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }
    weight =50;
    
}

- (void)saveStatus
{
    [[NSUserDefaults standardUserDefaults] setDouble:_time forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setDouble:_totalDistance forKey:@"distance"];
    [[NSUserDefaults standardUserDefaults] setInteger:_calorie forKey:@"calorie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)discardStatus
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsRiding"];
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"distance"];
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
    
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(updateTime:)])
            [obj updateTime:_time];
    }
}


- (void)stopRiding
{
    
    [locmanager stopUpdatingLocation];
    [locmanager stopUpdatingHeading];
    
    
    _totalDistance =0;
    _time=0;
    
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
            
            NSLog(@"저장 취소");
            break;
        }
        case 1:
        {
            RidingDB *ridingDB = [[RidingDB alloc] init];
            [ridingDB saveRecordingTime:[NSString stringWithFormat:@"%f", time] withDistance:[NSString stringWithFormat:@"%f", _totalDistance] withAverageSpeed:[NSString stringWithFormat:@"%f", [self avgSpeed]] withlocation:locations withCalories:@"20"];
            // save database
            
            NSLog(@"저장 완료");
            [ridingDB release];
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

//km/h
- (double)avgSpeed
{
    //total distance = m
    //time = h
    return (_totalDistance/1000.0)/(_time/60.0/60.0);
    
    
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


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    
    
    [locations addObject:newLocation];
    
    if([newLocation speed])
    {
        if(_max_speed==0)
            _max_speed = [newLocation speed];
        else if(_max_speed < [newLocation speed])
            _max_speed = [newLocation speed];
    }
    
    if(oldLocation){
        _totalDistance += [oldLocation distanceFromLocation:newLocation];
        if([oldLocation speed])
        _calorie += weight * (([[newLocation timestamp] timeIntervalSince1970]-[[oldLocation timestamp] timeIntervalSince1970])/60.0) * [self calculateCalorie:[oldLocation speed]*3.6];
        
    }

    
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)])
        [obj locationManager:self didUpdateToLocation:newLocation fromLocation:oldLocation];
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

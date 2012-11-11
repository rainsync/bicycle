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

@synthesize totalDistance,time;


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
            totalDistance = [[NSUserDefaults standardUserDefaults] doubleForKey:@"distance"];
            time = [[NSUserDefaults standardUserDefaults] doubleForKey:@"time"];
            if(totalDistance==0 && time ==0)
                @throw [NSException exceptionWithName:@"Setting" reason:@"old data is not correct" userInfo:nil];
            
        }
        @catch (NSException *exception) {
            totalDistance=0;
            time =0;
        }
        
        
    }else{
        
        
        
        totalDistance=0;
        time =0;
        
        locations = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsRiding"];
        [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"time"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }
    
}

- (void)saveStatus
{
    [[NSUserDefaults standardUserDefaults] setDouble:time forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setDouble:totalDistance forKey:@"distance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    time+=[[NSDate date] timeIntervalSince1970]-oldt;
    oldt=[[NSDate date] timeIntervalSince1970];
    
    [self saveStatus];
    
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(updateTime:)])
            [obj updateTime:time];
    }
}


- (void)stopRiding
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"기록 측정 종료" message:@"저장하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"네넹", nil];
    [alertView show];
    [alertView release];
}

- (void)discard
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsRiding"];
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"distance"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
            [ridingDB saveRecordingTime:[NSString stringWithFormat:@"%f", time] withDistance:[NSString stringWithFormat:@"%f", totalDistance] withAverageSpeed:[NSString stringWithFormat:@"%f", [self avgSpeed]] withlocation:locations withCalories:@"20"];
            // save database
            
            NSLog(@"저장 완료");
            [ridingDB release];
            break;
        }
    }
    
    
    [self discard];
    
    [locmanager stopUpdatingLocation];
    [locmanager stopUpdatingHeading];

    
    totalDistance =0;
    time=0;
    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(RidingStopped)])
            [obj RidingStopped];
    }
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
    return (totalDistance/1000.0)/(time/60.0/60.0);
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locations addObject:newLocation];

    
    if(oldLocation)
        totalDistance += [oldLocation distanceFromLocation:newLocation];

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

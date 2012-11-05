//
//  LocationManager.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "RidingManager.h"

@implementation RidingManager

//@synthesize locations;

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



- (void)startRiding
{
    if([self isRiding])
    {
        //unexpectly exit case
        
        //load previous path
        
        //reInvoke previous path

        
        //[self locationManager:locmanager didUpdateLocations:locations];
        

        
    }
    else{
        locations = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsRiding"];
    }
    
    
    [locmanager startUpdatingLocation];
    [locmanager startUpdatingHeading];
    
    
}

- (void)stopRiding
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsRiding"];
    
}

- (BOOL)isRiding
{
   return [[NSUserDefaults standardUserDefaults] boolForKey:@"IsRiding"];

}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locations addObject:newLocation];
    
    for (id obj in targets) {
        if([obj respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)])
        [obj locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
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
    
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    
    
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    
}

@end

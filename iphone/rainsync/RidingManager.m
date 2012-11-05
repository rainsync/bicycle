//
//  LocationManager.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "RidingManager.h"

@implementation RidingManager

- (id)init
{
    locmanager = [[CLLocationManager alloc] init];
    locmanager.delegate = self;
    locationUpdate = @selector(locationUpdate:location:);
    HeadingUpdate = @selector(headingUpdate:heading:);
    
    return self;
}



- (void)addTarget:(id)obj
{
    [targets addObject:obj];
}



- (void)startRiding
{
    if([RidingManager isRiding])
    {
        //unexpectly exit case
        
        //load previous path
        
        //reInvoke previous path

        
        location(locmanager, locations);
        

        
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

+ (BOOL)isRiding
{
   return [[NSUserDefaults standardUserDefaults] boolForKey:@"IsRiding"];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (id obj in targets) {
        [obj performSelector:locationUpdate withObject:@[manager, locations]];
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

    for (id obj in targets){
        [obj performSelector:HeadingUpdate withObject:@[manager,error]];
    }
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

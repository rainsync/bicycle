//
//  LocationManager.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "RidingManager.h"

@implementation RidingManager

- (id)initWithLocation:(void(^)(CLLocationManager*, NSArray*))locblock WithHeading:(void(^)(CLLocationManager*, CLHeading*))headblock
{
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    location = locblock;
    heading = headblock;
    return self;
}

- (void)startRiding
{
    if([RidingManager isRiding])
    {
        //unexpectly exit case
        
        //load previous path
        
        //reInvoke previous path
        NSArray* locations;
        
        location(manager, locations);
        

        
    }
    else
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsRiding"];
    
    [manager startUpdatingLocation];
    [manager startUpdatingHeading];
    
    
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

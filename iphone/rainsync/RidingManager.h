//
//  LocationManager.h
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RidingDB.h"
#import "Utility.h"

@interface RidingManager : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>
{

    CLLocationManager *locmanager;
    
    //Array of CLLocation
    double oldt;
    NSTimer *timer;
    NSMutableArray* targets;
    NSMutableArray* locations;
//    int calorie;
    int weight;
    RidingDB *ridingDB;
    
    //inital speed
    
    

}


@property (nonatomic, readonly) double totalDistance;
@property (nonatomic, readonly) double time;
@property (nonatomic, readonly) double calorie;
@property (nonatomic, readonly) double max_speed;
@property (nonatomic, readonly) CLLocation *current_location;


- (id)init;
- (void)startRiding;
- (void)stopRiding;
- (void)pauseRiding;
- (BOOL)isRiding;
- (void)addTarget:(id)obj;
+ (RidingManager *)getInstance;
- (double)avgSpeed;
- (void)discard;

@end

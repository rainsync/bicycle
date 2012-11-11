//
//  LocationManager.h
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface RidingManager : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>
{

    CLLocationManager *locmanager;
    
    //Array of CLLocation
    double oldt;
    NSTimer *timer;
    NSMutableArray* targets;
    NSMutableArray* locations;

}

//@property (nonatomic,retain) NSMutableArray* locations;
@property (nonatomic, readonly) double totalDistance;
@property (nonatomic, readonly) double time;

- (id)init;
- (void)startRiding;
- (void)stopRiding;
- (void)pauseRiding;
- (BOOL)isRiding;
- (void)addTarget:(id)obj;
+ (RidingManager *)getInstance;
- (NSMutableArray*)getlocations;
- (double)avgSpeed;
- (void)discard;

@end

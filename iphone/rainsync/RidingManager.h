//
//  LocationManager.h
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface RidingManager : NSObject <CLLocationManagerDelegate>
{

    CLLocationManager *locmanager;
    
    //Array of CLLocation
    
    NSMutableArray* targets;
    NSMutableArray* locations;


}

//@property (nonatomic,retain) NSMutableArray* locations;

- (id)init;
- (void)startRiding;
- (void)stopRiding;
- (BOOL)isRiding;
- (void)addTarget:(id)obj;
+ (RidingManager *)getInstance;
- (NSMutableArray*)getlocations;

@end

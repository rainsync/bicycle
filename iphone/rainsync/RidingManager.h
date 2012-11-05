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
//    @private void (^location)(CLLocationManager*, NSArray*);
//    @private void (^heading)(CLLocationManager*, CLHeading*);
    CLLocationManager *locmanager;
    
    //Array of CLLocation
    NSMutableArray* locations;
    NSMutableArray* targets;
    SEL locationUpdate;
    SEL HeadingUpdate;

}

- (id)init;
- (void)startRiding;
- (void)stopRiding;
- (BOOL)isRiding;

@end

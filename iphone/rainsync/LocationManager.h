//
//  LocationManager.h
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    @private void (^location)(NSArray*);
    @private void (^heading)(CLHeading*);

}
- (id)initWithLocation:(void(^)(NSArray*))location WithHeading:(void(^)(CLHeading*))heading;
- (void)startRiding;
- (void)stopRiding;
+ (BOOL)isRiding;

@end

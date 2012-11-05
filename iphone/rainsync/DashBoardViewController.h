//
//  DashBoardViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//<CoreLocationControllerDelegate>

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"
#import "RidingManager.h"


@interface DashBoardViewController : UIViewController <CoreLocationControllerDelegate>
- (void)locationUpdate:(CLLocationManager*)manager WithLocations:(NSArray*)locations;
- (void)headingUpdate:(CLLocationManager*)manager WithLocations:(CLHeading*)heading;

@property (nonatomic, retain) IBOutlet UILabel *speedLabel;
@property (nonatomic, retain) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *longitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *altitudeLabel;
@end

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
#import "Utility.h"


@interface DashBoardViewController : UIViewController <CoreLocationControllerDelegate>
{
    bool paused;
    
}
@property (nonatomic, retain) IBOutlet UILabel *speedLabel;
@property (nonatomic, retain) IBOutlet UILabel *avgLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *calorieLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UIButton *stopButton;
@property (retain, nonatomic) IBOutlet UILabel *stopLabel;
@property (retain, nonatomic) IBOutlet UIButton *statusButton;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@end

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
    bool first;
    BOOL isSingleMode;
    
    NSMutableArray *numberArray;
}
//@property (nonatomic, retain) NSMutableArray *numberArray;

@property (nonatomic, retain) IBOutlet UILabel *speedLabel;
@property (nonatomic, retain) IBOutlet UILabel *avgLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *calorieLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UIButton *stopButton;
@property (retain, nonatomic) IBOutlet UILabel *stopLabel;
@property (retain, nonatomic) IBOutlet UIButton *statusButton;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIButton *modeChangeButton;

@property (retain, nonatomic) IBOutlet UIImageView *time_second1;
@property (retain, nonatomic) IBOutlet UIImageView *time_second10;
@property (retain, nonatomic) IBOutlet UIImageView *time_minute1;
@property (retain, nonatomic) IBOutlet UIImageView *time_minute10;
@property (retain, nonatomic) IBOutlet UIImageView *time_hour1;
@property (retain, nonatomic) IBOutlet UIImageView *time_hour10;


- (IBAction)modeChange:(id)sender;
@end

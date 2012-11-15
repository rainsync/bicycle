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
    

}
//@property (nonatomic, retain) NSMutableArray *numberArray;
@property (nonatomic, retain) IBOutlet UIImageView *speedLabel;
@property (nonatomic, retain) IBOutlet UIImageView *avgLabel;
@property (nonatomic, retain) IBOutlet UIImageView *timeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *calorieLabel;
@property (retain, nonatomic) IBOutlet UIImageView *distanceLabel;
@property (retain, nonatomic) IBOutlet UIButton *stopButton;
@property (retain, nonatomic) IBOutlet UILabel *stopLabel;
@property (retain, nonatomic) IBOutlet UIButton *statusButton;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIButton *modeChangeButton;
@property (retain, nonatomic) IBOutlet UILabel *modeLabel;
- (IBAction)modeChange:(id)sender;
@end

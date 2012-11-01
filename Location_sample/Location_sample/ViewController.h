//
//  ViewController.h
//  Location_sample
//
//  Created by 승원 김 on 12. 10. 24..
//  Copyright (c) 2012년 승원 김. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>
{
    CLLocationManager *locationManger;
    UILabel *latitude;
    UILabel *longitude;
    UILabel *horizontalAccuracy;
    UILabel *altitude;
    UILabel *verticalAccuracy;
    UILabel *distance;
    UIButton *resetButton;
    CLLocation *startLocation;
    
    UILabel *recordingTime;
    NSTimer *_timer;
    BOOL isPaused;
    BOOL isEnded;
    int timeCounter;
    float speed;

}
@property (strong, nonatomic) CLLocationManager *locationManger;
@property (strong, nonatomic) IBOutlet UILabel *latitude;
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *horizontalAccuracy;
@property (strong, nonatomic) IBOutlet UILabel *altitude;
@property (strong, nonatomic) IBOutlet UILabel *verticalAccuracy;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) CLLocation *startLocation;
@property (strong, nonatomic) IBOutlet UIButton *startRecordBtn;
@property (strong, nonatomic) IBOutlet UIButton *resumeRecordBtn;
@property (strong, nonatomic) IBOutlet UIButton *pauseRecordBtn;
@property (strong, nonatomic) IBOutlet UIButton *endRecordBtn;
@property (strong, nonatomic) IBOutlet UILabel *recordingTime;
@property (strong, nonatomic) IBOutlet UILabel *currentSpeed;

- (IBAction)resetDistance;
- (IBAction)startRecording:(id)sender;
- (IBAction)resumeRecording:(id)sender;
- (IBAction)pauseRecording:(id)sender;
- (IBAction)endRecording:(id)sender;

- (void)checkTime:(NSTimer *)timer;
@end

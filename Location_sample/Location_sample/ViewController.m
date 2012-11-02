//
//  ViewController.m
//  Location_sample
//
//  Created by 승원 김 on 12. 10. 24..
//  Copyright (c) 2012년 승원 김. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize locationManger;
@synthesize latitude, longitude, altitude, horizontalAccuracy, verticalAccuracy, distance, resetButton;
@synthesize startLocation;
@synthesize recordingTime;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManger = [[CLLocationManager alloc] init];
    locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    locationManger.delegate = self;
    [locationManger startUpdatingLocation];
    startLocation = nil;
    
    [recordingTime setText:@"00:00:00"];
    isPaused = NO;
    isEnded = NO;
    timeCounter = 0;
    avgSpeed = 0.0f;
    
    _resumeRecordBtn.hidden = YES;
    _pauseRecordBtn.hidden = YES;
    _endRecordBtn.hidden = YES;
    
    [_weight setText:@"70"];
}

- (void)resetDistance
{
    NSLog(@"restDistance is called.");
    startLocation = nil;
}

- (IBAction)startRecording:(id)sender {
    isPaused = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkTime:) userInfo:nil repeats:YES];

    _startRecordBtn.hidden = YES;
    _pauseRecordBtn.hidden = NO;
}

- (IBAction)resumeRecording:(id)sender {
    isPaused = NO;
    _resumeRecordBtn.hidden = YES;
    _pauseRecordBtn.hidden = NO;
}

- (IBAction)pauseRecording:(id)sender {
    isPaused = YES;
    
    _resumeRecordBtn.hidden = NO;
    _endRecordBtn.hidden = NO;
    _pauseRecordBtn.hidden = YES;

}

- (IBAction)endRecording:(id)sender {
    isEnded = NO;
    [_timer invalidate];
    
    _startRecordBtn.hidden = NO;
    _resumeRecordBtn.hidden = YES;
    
    // 결과 출력
    float distanceFloat = [distance.text floatValue];
    NSString *result = [NSString stringWithFormat:@"주행시간: %d\n주행거리: %.2f", timeCounter, distanceFloat];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"기록 측정 완료" message:result delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
    
    // 초기화
    timeCounter = 0;
    avgSpeed = 0.0f;
    [recordingTime setText:@"00:00:00"];
    [_currentSpeed setText:@"0"];
    [self resetDistance];
}

- (void)checkTime:(NSTimer *)timer {
    if (isPaused) {
        // 일시정지 중에는 시간이 흐르지 않음
    }
    else if (isPaused == NO) {
        [recordingTime setText:[NSString stringWithFormat:@"%d", ++timeCounter]];
        avgSpeed = ([distance.text floatValue] / 1000.0) / ((float)timeCounter / 3600.0) ;
        [_averageSpeed setText:[NSString stringWithFormat:@"%.6f", avgSpeed]];
        
        [_calorie setText:[NSString stringWithFormat:@"%.6f", [_weight.text intValue] * [self calculateCalorie:avgSpeed] * (timeCounter / 60.0)]];
        NSLog(@"%d", [_weight.text intValue]);
        NSLog(@"%f", [self calculateCalorie:avgSpeed]);
        NSLog(@"%f", timeCounter / 60.0);
    }
}

- (float)calculateCalorie:(float)avgSpd {
    float kcalConstant = 0.0f;
    if (avgSpd <= 13) {
        kcalConstant = 0.065f;
    }
    else if (avgSpd <= 16) {
        kcalConstant = 0.0783f;
    }
    else if (avgSpd <= 19) {
        kcalConstant = 0.0939f;
    }
    else if (avgSpd <= 22) {
        kcalConstant = 0.113f;
    }
    else if (avgSpd <= 24) {
        kcalConstant = 0.124f;
    }
    else if (avgSpeed <= 26) {
        kcalConstant = 0.136f;
    }
    else if (avgSpeed <= 27) {
        kcalConstant = 0.149f;
    }
    else if (avgSpeed <= 29) {
        kcalConstant = 0.163f;
    }
    else if (avgSpeed <= 31) {
        kcalConstant = 0.179f;
    }
    else if (avgSpeed <= 32) {
        kcalConstant = 0.196f;
    }
    else if (avgSpeed <= 34) {
        kcalConstant = 0.215f;
    }
    else if (avgSpeed <= 37) {
        kcalConstant = 0.259f;
    }
    else {  // avgSpeed 40km/h 이상
        kcalConstant = 0.311f;
    }

    NSLog(@"%f", kcalConstant);

    return kcalConstant;
}

- (void)sliderChanged:(id)sender {
	int progressAsInt = (int)(_weightSlider.value + 0.5f);
	NSString *newText = [[NSString alloc]
						 initWithFormat:@"%d",
						 progressAsInt];
	_weight.text = newText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWeightSlider:nil];
    [self setWeight:nil];
    [self setCalorie:nil];
    [self setCurrentSpeed:nil];
    [self setCurrentSpeed:nil];
    [self setResumeRecordBtn:nil];
    [self setEndRecordBtn:nil];
    [self setPauseRecordBtn:nil];
    [self setStartRecordBtn:nil];
    self.latitude = nil;
    self.longitude = nil;
    self.horizontalAccuracy = nil;
    self.altitude = nil;
    self.verticalAccuracy = nil;
    self.startLocation = nil;
    self.distance = nil;
    self.locationManger = nil;
    self.recordingTime = nil;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocation *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
    latitude.text = currentLatitude;
    
    NSString *currentLongitude = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
    longitude.text = currentLongitude;
    
    NSString *currentHorizontalAccuracy = [[NSString alloc] initWithFormat:@"%g", newLocation.horizontalAccuracy];
    horizontalAccuracy.text = currentHorizontalAccuracy;
    
    NSString *currentAltitude = [[NSString alloc] initWithFormat:@"%g", newLocation.altitude];
    altitude.text = currentAltitude;
    
    NSString *currentVerticalAccuracy = [[NSString alloc] initWithFormat:@"%g", newLocation.verticalAccuracy];
    verticalAccuracy.text = currentVerticalAccuracy;
    
    NSString *currentSpeed = [[NSString alloc] initWithFormat:@"%g", newLocation.speed];
    _currentSpeed.text = currentSpeed;
    
    if (startLocation == nil) {
        self.startLocation = newLocation;
    }
    
    CLLocationDistance distanceBetween = [newLocation distanceFromLocation:startLocation];
    NSString *tripString = [[NSString alloc] initWithFormat:@"%f", distanceBetween];
    distance.text = tripString;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

@end

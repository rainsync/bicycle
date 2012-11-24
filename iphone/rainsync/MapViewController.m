//
//  MapViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {



        

        
        ridingManager = [self.tabBarController getRidingManager];
        [ridingManager addTarget:self];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isHeading = FALSE;
    [self setHeading:self];
//    [self setTrackUser:self];
    
    
    if([ridingManager isRiding]){
    
    }
    
   
    
    

        // Do any additional setup after loading the view from its nib.
}




- (IBAction)changeMap:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"일반 지도", @"위성 지도", @"일반 + 위성 지도", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

- (IBAction)setHeading:(id)sender {
    if(isHeading) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:false];
        isHeading = FALSE;
    }
    else {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:true];
        isHeading = TRUE;
    }
}

- (IBAction)setTrackUser:(id)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:true];
}

- (IBAction)setNoTrack:(id)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:false];
}





- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

@end

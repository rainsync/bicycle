//
//  GroupRideViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "GroupRideViewController.h"
#import "InviteUserViewController.h"

@interface GroupRideViewController ()

@end

@implementation GroupRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"그룹라이딩";
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* RidingType = [[NSUserDefaults standardUserDefaults] stringForKey:@"RidingType"];
    if([RidingType isEqualToString:@"Single"])
        [_GroupRiding setOn:FALSE];
    else
        [_GroupRiding setOn:TRUE];
    
    
    // Do any additional setup after loading the view from its nib.
}
    
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


- (IBAction)ridingChange:(id)sender {
    if(_GroupRiding.on)
        [[NSUserDefaults standardUserDefaults]  setValue:@"Group" forKey:@"RidingType"];
    else
        [[NSUserDefaults standardUserDefaults]  setValue:@"Single" forKey:@"RidingType"];
    
}

- (IBAction)inviteUser:(id)sender {
    InviteUserViewController *inviteUserViewController = [[InviteUserViewController alloc] initWithNibName:@"InviteUserViewController" bundle:nil];

    [self.navigationController pushViewController:inviteUserViewController animated:FALSE];
    [inviteUserViewController release];


//    [UIView beginAnimations:@"left flip" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView: self.view.superview cache:YES];
//    [self.view addSubview:inviteUserViewController.view];
//    [UIView commitAnimations];
}

- (IBAction)startRiding:(id)sender {

//    RidingViewController *ridingController = [[RidingViewController alloc] initWithNibName:@"RidingViewController" bundle:nil];
    //[self.view.superview addSubview:ridingController.view];
    
  //  [[[UIApplication sharedApplication] keyWindow] setRootViewController:ridingController];
    
    //	self.ridingViewController = ridingController;
//	[self.view insertSubview:ridingController.view atIndex:0];
//    [self.view addSubview:ridingController.view];
//	[ridingController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_GroupRiding release];
    [_inviteUserBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setGroupRiding:nil];
    [self setInviteUserBtn:nil];
    [super viewDidUnload];
}
@end

//
//  ViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (id)init
{
    [super init];
    ProfileViewController* profile = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    GroupRideViewController* groupriding = [[GroupRideViewController alloc]initWithNibName:@"GroupRideViewController" bundle:nil];
    RidingViewController* riding = [[RidingViewController alloc]initWithNibName:@"RidingViewController" bundle:nil];
    StaticViewController* statics = [[StaticViewController alloc]initWithNibName:@"StaticViewController" bundle:nil];
    SettingViewController* setting = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    //[self.tabBarItem]
    
    self.viewControllers = @[profile, groupriding, riding,statics, setting];
    return self;
    
}
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

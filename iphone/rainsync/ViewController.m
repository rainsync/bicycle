//
//  ViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ViewController.h"
#import "PrettyKit.h"
#import "UIColor+ColorWithHex.h"

@interface ViewController ()

@end


@implementation ViewController


- (RidingManager *)getRidingManager
{
    return ridingManager;
    
}

- (id)init
{
    [super init];
    ridingManager = [[RidingManager alloc] init];

    
    RidingViewController *riding = [RidingViewController alloc];
    UINavigationController *ridingViewNavController = [UINavigationController alloc];
    [ridingViewNavController initWithRootViewController:riding];
    
    ProfileViewController* profile = [ProfileViewController alloc];
    UINavigationController *profileNavController = [UINavigationController alloc];
    [profileNavController initWithRootViewController:profile];
    
    StaticViewController* statics = [StaticViewController alloc];
    UINavigationController *staticsNavController = [UINavigationController alloc];
    [staticsNavController initWithRootViewController:statics];
                                                   
    SettingViewController* setting = [SettingViewController alloc];  
    UINavigationController *settingNavController = [UINavigationController alloc];
    [settingNavController initWithRootViewController:setting];
                                                   

    self.viewControllers = @[ridingViewNavController,profileNavController,staticsNavController, settingNavController];
    
    
    [riding initWithNibName:@"RidingViewController" bundle:nil];
    [ridingViewNavController setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];
    
    [profile initWithNibName:@"ProfileViewController" bundle:nil];
    [profileNavController setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];
    
    [statics initWithNibName:@"StaticViewController" bundle:nil];
    [staticsNavController setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];
    
    [setting initWithNibName:@"SettingViewController" bundle:nil];
    [settingNavController setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];
    
    self.tabBar.selectedImageTintColor = [UIColor colorWithHexString:@"008fd5"];
    
    [riding release];
    [profile release];
    [statics release];
    [setting release];
    
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

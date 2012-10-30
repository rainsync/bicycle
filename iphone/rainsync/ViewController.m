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
    ridingViewController = [[RidingViewController alloc] initWithNibName:@"RidingViewController" bundle:nil];
    [self addChildViewController:ridingViewController];
    
    
    ProfileViewController* profile = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *profileNavController = [[UINavigationController alloc] initWithRootViewController:profile];
    
    GroupRideViewController* groupriding = [[GroupRideViewController alloc]initWithNibName:@"GroupRideViewController" bundle:nil];

//    RidingViewController* riding = [[RidingViewController alloc]initWithNibName:@"RidingViewController" bundle:nil];

    StaticViewController* statics = [[StaticViewController alloc]initWithNibName:@"StaticViewController" bundle:nil];
    UINavigationController *staticsNavController = [[UINavigationController alloc] initWithRootViewController:statics];
    
    SettingViewController* setting = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *settingNavController = [[UINavigationController alloc] initWithRootViewController:setting];
    
    //[self.tabBarItem]
    
    
    // 네이비게이션 바가 필요한 프로필 탭, 통계 탭, 설정 탭은 네비게이션 컨트롤러에 뷰 삽입하여 탭바 컨트롤러에 삽임한다.
    self.viewControllers = @[profileNavController, groupriding, staticsNavController, settingNavController];
    
    
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

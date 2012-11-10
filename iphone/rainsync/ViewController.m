//
//  ViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ViewController.h"
#import "PrettyKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)init
{
    [super init];
    
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0 green:.2 blue:.4 alpha:1.0f]];
    
    //ridingViewController = [[RidingViewController alloc] initWithNibName:@"RidingViewController" bundle:nil];
    //[self addChildViewController:ridingViewController];
    
    RidingViewController *ridingViewController = [[RidingViewController alloc] initWithNibName:@"RidingViewController" bundle:nil];
//    UINavigationController *ridingViewNavController = [[UINavigationController alloc] initWithRootViewController:ridingViewController];

    
    ProfileViewController* profile = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *profileNavController = [[UINavigationController alloc] initWithRootViewController:profile];
    [profileNavController setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];
    
    StaticViewController* statics = [[StaticViewController alloc]initWithNibName:@"StaticViewController" bundle:nil];
    UINavigationController *staticsNavController = [[UINavigationController alloc] initWithRootViewController:statics];
    [staticsNavController setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];
    
    SettingViewController* setting = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *settingNavController = [[UINavigationController alloc] initWithRootViewController:setting];
    [settingNavController setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];
    
    // 네이비게이션 바가 필요한 프로필 탭, 통계 탭, 설정 탭은 네비게이션 컨트롤러에 뷰 삽입하여 탭바 컨트롤러에 삽임한다.
    self.viewControllers = @[ridingViewController, profileNavController,staticsNavController, settingNavController];

    [ridingViewController release];
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

- (void)changeToRiding {
    
}
@end

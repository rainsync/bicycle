//
//  FirstSettingViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 10. 29..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "FirstSettingViewController.h"
#import "ViewController.h"



@interface FirstSettingViewController ()

@end

@implementation FirstSettingViewController
//@synthesize fbButton, generalLoginButton;
//@synthesize selectFbOrGeneralView, nameAndAvatarSettingView, compeletionSettingView;






- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)fbLogin:(id)sender {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    
    
    // get the app delegate so that we can access the session property
    [[Login getInstance] join:^{
        [HUD hide:YES];
        ViewController *viewController = [[ViewController alloc] init];
        [[[UIApplication sharedApplication] keyWindow]setRootViewController:viewController];
        [self.view removeFromSuperview];
        [viewController release];
    } withFail:^(NSError *error) {
        [HUD hide:YES];
    }];
   

    
}

- (void)hudWasHidden:(MBProgressHUD *)HUD {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

- (IBAction)generalLogin:(id)sender {

    ViewController *viewController = [[ViewController alloc] init];
    [[[UIApplication sharedApplication] keyWindow]setRootViewController:viewController];
    [self.view removeFromSuperview];
    [viewController release];
}

- (void)dealloc {
    [_fbButton release];
    [_generalLoginButton release];
    [_indicator release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFbButton:nil];
    [self setGeneralLoginButton:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
}



@end

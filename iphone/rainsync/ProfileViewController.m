//
//  ProfileViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileEditViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"프로필", @"프로필");
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)login:(id)sender {
    [_disableView setHidden:YES];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)editProfile {
    ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] initWithNibName:@"ProfileEditViewController" bundle:nil];
    [self.navigationController pushViewController:profileEditViewController animated:NO];
    [profileEditViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_Name release];
    [_profileImageView release];
    [_disableView release];
    [_loginButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setName:nil];
    [self setProfileImageView:nil];
    [self setDisableView:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
}
@end

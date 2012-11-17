//
//  ProfileViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileEditViewController.h"
#import "PrettyKit.h"
#import "UIColor+ColorWithHex.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProfileViewController


- (void) reqSuccess:(int)message withJSON:(NSDictionary *)dic {
    switch (message) {
        case account_profile_get:
        {
            NSInteger state=[[dic objectForKey:@"state"] intValue];
            NSString *nick=[dic objectForKey:@"nick"];
            NSString *picture=[dic objectForKey:@"picture"];
            NSString *email=[dic objectForKey:@"email"];
            
            if(state==0){
            [_Name setText:nick];
            [_Email setText:email];
            [_profileImageView setImageWithURL:[[[NSURL alloc] initWithString:picture]autorelease]];    
            NSLog([NSString stringWithFormat:@"STATE %d NICK %@ PICTURE %@ EMAIL %@", state, nick, picture, email]);
            
            
            
                
            }
            
            break;

        }
        default:
        {
            NSError *error=[NSError errorWithDomain:@"서버로 부터 잘못된 데이터가 전송되었습니다." code:-2 userInfo:nil];
            break;
        }
    }
    
}

- (void)reqFail:(NSError*)error
{
    //[self showError:error];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"프로필", @"프로필");
        [[NetUtility getInstance] addHandler:self];
        // Custom initialization
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = self.editProfileButton;
    self.editProfileButton.title = @"수정";
    
    CALayer *layer = [_profileImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:30.0];   // 프로필 사진에 레이어를 씌워 라운딩 처리
}

- (void)hudWasHidden:(MBProgressHUD *)HUD {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

- (IBAction)login:(id)sender {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    HUD.dimBackground = YES;
    [HUD show:TRUE];
    
    //[_disableView setHidden:YES];
    [[Login getInstance] join:^{
        [HUD hide:TRUE];
        [_disableView setHidden:TRUE];
        [[NetUtility getInstance] account_profile_get:[[Login getInstance] getSession]];
        [[NetUtility getInstance] end];
    } withFail:^(NSError *error) {
        [HUD hide:TRUE];
        [_disableView setHidden:FALSE];
    }];
    
}

- (IBAction)editProfile:(id)sender {
    ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] initWithNibName:@"ProfileEditViewController" bundle:nil];
    [self.navigationController pushViewController:profileEditViewController animated:YES];
    [profileEditViewController release];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *session =[[Login getInstance] getSession];
    if(session)
    {
        
        [[NetUtility getInstance] account_profile_get:session];
        [[NetUtility getInstance] end];
        [_disableView setHidden:TRUE];
        
    }else{
        [_disableView setHidden:FALSE];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_editProfileButton release];
    [_tableView release];
    [super dealloc];
    
    [_Name release];
    [_profileImageView release];
    [_disableView release];
    [_loginButton release];
    [_Email release];

}
- (void)viewDidUnload {
    [self setName:nil];
    [self setProfileImageView:nil];
    [self setDisableView:nil];
    [self setLoginButton:nil];
    [self setEmail:nil];
    [self setEditProfileButton:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}


@end

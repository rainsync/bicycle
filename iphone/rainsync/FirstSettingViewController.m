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
    // get the app delegate so that we can access the session property
    
    
    // this button's job is to flip-flop the session from open to closed
    if (FBSession.activeSession.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [FBSession.activeSession closeAndClearTokenInformation];
        
    } else {
        
        
        if (FBSession.activeSession.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            FBSession.activeSession= [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
            
            NetUtility *net = [[NetUtility alloc] initwithBlock:^(int msg, NSDictionary * dic) {
                if(msg==account_register)
                {
                    /*
                    NSInteger state=[[dic objectForKey:@"state"] intValue];
                    
                    if(state==0)
                    {
                        
                    //NSInteger uid=[[dic objectForKey:@"uid"] intValue];
                    //NSString *passkey=[dic objectForKey:@"passkey"];
                    //NSLog([NSString stringWithFormat:@"STATE %d UID %d PASSKEY %@", state, uid, passkey]);
                    [[NSUserDefaults standardUserDefaults] setObject:FBSession.activeSession.accessToken forKey:@"token"];
                        
                    ViewController *viewController = [[ViewController alloc] init];
                    [[[UIApplication sharedApplication] keyWindow]setRootViewController:viewController];
                        
                        
                    }
                    */
                }
            }];
            NSLog(@"WW");
            [net account_registerwithAcessToken:FBSession.activeSession.accessToken withNick:@"" withPhoto:@""];
            //[net end];
            
        }];
        
        // and here we make sure to update our UX according to the new session state
        
        
        
    }
    
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
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFbButton:nil];
    [self setGeneralLoginButton:nil];
    [super viewDidUnload];
}
@end

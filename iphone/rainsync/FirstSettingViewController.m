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


- (void)sessionStateChanged:(FBSession *)session
{
    NetUtility *net = [[NetUtility alloc] initwithBlock:^(int msg, NSDictionary * dic) {
        if(msg==account_register)
        {
            
            NSInteger state=[[dic objectForKey:@"state"] intValue];
            
            if(state==0)
            {
                
                NSInteger uid=[[dic objectForKey:@"uid"] intValue];
                NSString *passkey=[dic objectForKey:@"passkey"];
                NSLog([NSString stringWithFormat:@"STATE %d UID %d PASSKEY %@", state, uid, passkey]);
                [[NSUserDefaults standardUserDefaults] setObject:FBSession.activeSession.accessToken forKey:@"token"];
                
                ViewController *viewController = [[ViewController alloc] init];
                [[[UIApplication sharedApplication] keyWindow]setRootViewController:viewController];
                
                
            }
            
        }
        
        //NSLog(@"rc2 %d ",[net retainCount]);
        //[net release];
    }];
    
    [net account_registerwithAcessToken:FBSession.activeSession.accessToken withNick:@"" withPhoto:@""];
    [net end];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];
        
        
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
    
    
    [[[UIApplication sharedApplication] delegate] openSessionWithAllowLoginUI:YES];

    
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

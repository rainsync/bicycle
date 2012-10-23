//
//  ProfileViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileViewController.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize fbloginbutton;

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
    [self test];
    [self updateView];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
    
}




- (void)test
{
    NetUtility* net = [[[NetUtility alloc] init] autorelease];
    [net getURL:@"http://www.search.twitter.com/search.json?q=from:nathanhjones" withBlock:^(NSData* result){
        
        //NSString* test= [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding ];
        
         // convert to JSON
         NSError *myError = nil;
         NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"error %@", myError);
        
         // show all values
         for(id key in res) {
         
         id value = [res objectForKey:key];
         
         NSString *keyAsString = (NSString *)key;
         NSString *valueAsString = (NSString *)value;
         
         NSLog(@"key: %@", keyAsString);
         NSLog(@"value: %@", valueAsString);
         }
         
         // extract specific value...
         NSArray *results = [res objectForKey:@"results"];
         
         for (NSDictionary *result in results) {
         NSString *icon = [result objectForKey:@"icon"];
         NSLog(@"icon: %@", icon);
         }
        
     [result release];
     
     

    }];
    
    
    NSDictionary * json = [NSDictionary dictionaryWithObjectsAndKeys:@"method", @"setGPS", @"seq", @"1", nil];
    NSData* data = [NSJSONSerialization dataWithJSONObject:json options:NSUTF8StringEncoding error:nil];
    
    [net postURL:@"http://www.search.twitter.com/search.json?q=from:nathanhjones" withData:data withBlock:^(NSData * result) {
        NSLog(@"end!");
        //[data release];
        //[json release];
        
        
    }];
    
    /*
    [data release];
    [json release];
    */
    

    
}

// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        [self.fbloginbutton setTitle:@"Log out" forState:UIControlStateNormal];
         NSLog([NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", appDelegate.session.accessToken]);
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.fbloginbutton setTitle:@"Log in" forState:UIControlStateNormal];
        NSLog(@"Login to create a link to fetch account data");
    }
}

- (IBAction)fblogin:(id)sender{
    // get the app delegate so that we can access the session property
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

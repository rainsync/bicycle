//
//  AppDelegate.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "DashBoardViewController.h"
#import "FirstSettingViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [FBProfilePictureView class];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    

    NSString* RidingType = [[NSUserDefaults standardUserDefaults] stringForKey:@"RidingType"];
    if(!RidingType){
        RidingType = @"Single";
        [[NSUserDefaults standardUserDefaults] setValue:RidingType forKey:@"RidingType"];
    }
    
    NSString* IsRiding = [[NSUserDefaults standardUserDefaults] stringForKey:@"IsRiding"];
    if(!IsRiding){
        IsRiding = @"Stop";
        [[NSUserDefaults standardUserDefaults] setValue:IsRiding forKey:@"IsRiding"];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"IsStart"];
    
    NSString *IsStart = [[NSUserDefaults standardUserDefaults] stringForKey:@"IsStart"];
    if(!IsStart){
        FirstSettingViewController *firstSettingViewController = [[FirstSettingViewController alloc] initWithNibName:@"FirstSettingViewController" bundle:nil];
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstSettingViewController];
//        [navController.navigationBar setBarStyle:UIBarStyleBlack];
        
        self.viewController = firstSettingViewController;
        
    } else {
        
        self.viewController = [[ViewController alloc] init];
    }
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

// FBSample logic
// The native facebook application transitions back to an authenticating application when the user
// chooses to either log in, or cancel. The url passed to this method contains the token in the
// case of a successful login. By passing the url to the handleOpenURL method of a session object
// the session object can parse the URL, and capture the token for use by the rest of the authenticating
// application; the return value of handleOpenURL indicates whether or not the URL was handled by the
// session object, and does not reflect whether or not the login was successful; the session object's
// state, as well as its arguments passed to the state completion handler indicate whether the login
// was successful; note that if the session is nil or closed when handleOpenURL is called, the expression
// will be boolean NO, meaning the URL was not handled by the authenticating application
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}



@end

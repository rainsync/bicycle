//
//  Login.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 14..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "FBLogin.h"

@implementation FBLogin


- (id)init
{
    [super init];
    handler = [[NSMutableArray alloc] init];
    
    return self;
}


- (void)addHandler:(id)handle
{
    [handler addObject:handle];
}


-(void)dealloc
{
    [super dealloc];
    
}



/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                for (id handle in handler) {
                    if([handle respondsToSelector:@selector(FBloginFail:)])
                        [handle FBloginSuccess:session];
                }
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    
    
    
    if(error){
        for (id handle in handler) {
            if([handle respondsToSelector:@selector(FBloginFail:)])
                [handle FBloginFail:error];
        }

    }else{
        
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

@end

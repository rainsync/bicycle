//
//  Login.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 14..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "Login.h"

@implementation Login



+(Login*)getInstance
{
    static Login* _instance = nil;
    if(_instance == nil)
    {
        @synchronized(self)
        {
            if(_instance == nil)
            {
                _instance = [[Login alloc] init];
            }
        }
    }
    return _instance;
}

- (id)init
{
    [super init];
    Session=nil;
    [[NetUtility getInstance] addHandler:self];
    return self;
}


- (void) reqSuccess:(int)message withJSON:(NSDictionary *)dic {
    switch (message) {
        case account_register:
        {
            NSInteger state=[[dic objectForKey:@"state"] intValue];
            NSInteger uid=[[dic objectForKey:@"uid"] intValue];
            NSString *passkey=[dic objectForKey:@"passkey"];
            NSLog([NSString stringWithFormat:@"STATE %d UID %d PASSKEY %@", state, uid, passkey]);
            [self loginWithFacebookSession];
            break;
        }
        case account_auth:
        {
            NSInteger state=[[dic objectForKey:@"state"] intValue];
            NSString *sessid=[dic objectForKey:@"sessid"];
            if(state==0){
                NSLog([NSString stringWithFormat:@"STATE %d SESSION %@", state, sessid]);
                Session = sessid;
                [[NSUserDefaults standardUserDefaults] setObject:Session forKey:@"session"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                success();
            }
            break;
        }
            
        default:
        {
            NSError *error=[NSError errorWithDomain:@"서버로 부터 잘못된 데이터가 전송되었습니다." code:-2 userInfo:nil];
            [self showError:error];
            fail(error);
            break;
        }
    }

}

- (void)reqFail:(NSError*)error
{
    [self showError:error];
}

-(void)dealloc
{
    [super dealloc];
    
}

- (NSString *)getSession
{
    if(Session==nil){
    NSString *saved = [[NSUserDefaults standardUserDefaults] stringForKey:@"session"];
    if(saved)
        Session=saved;
    }
    
    return Session;
}

- (void)join:(void(^)(void))success_block withFail:(void(^)(NSError* error))fail_block{
    success = Block_copy(success_block);
    fail = Block_copy(fail_block);
    [self openSessionWithAllowLoginUI:TRUE];
    
}

- (void)showError:(NSError *)error
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}



- (void)joinWithFacebookSession{
    
    [[NetUtility getInstance] account_registerwithAcessToken:FBSession.activeSession.accessToken withNick:@"" withPhoto:@""];
    [[NetUtility getInstance] end];
}




- (void)loginWithFacebookSession
{
    
    [[NetUtility getInstance] account_auth:FBSession.activeSession.accessToken];
    [[NetUtility getInstance] end];
    
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
                [self joinWithFacebookSession];
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
    [self showError:error];
    fail(error);
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

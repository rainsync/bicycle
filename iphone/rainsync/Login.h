//
//  Login.h
//  rainsync
//
//  Created by xorox64 on 12. 11. 14..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetUtility.h"
#import <FacebookSDK/FacebookSDK.h>

@interface Login : NSObject
{
    @private void (^success)(void);
    @private void (^fail)(NSError* error);
    @private NSString *Session;

    
}

+(Login*)getInstance;
- (NSString *)getSession;
- (void)join:(void(^)(void))success withFail:(void(^)(NSError* error))fail;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)loginWithFacebookSession;
- (void)joinWithFacebookSession;

@end

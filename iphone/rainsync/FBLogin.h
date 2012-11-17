//
//  Login.h
//  rainsync
//
//  Created by xorox64 on 12. 11. 14..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBLogin : NSObject
{
    NSMutableArray *handler;
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end

//
//  NetUtility.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Queue.h"
#import "AFJSONRequestOperation.h"
#import "Login.h"

enum req_type{
    account_register=1,
    account_auth=2,
    account_profile_get=3,
    account_friend_list=4,
    race_info=5,
    
};



@interface NetUtility : NSObject{

    @private void (^success)(int, NSDictionary*);
    @private void (^fail)(NSError *);
    NSMutableArray *handler;
    @private NSMutableArray* arr;
    @private Queue *queue;
    @private NSString *server;
    
}
+(NetUtility*)getInstance;
-(id)init;
-(void) dealloc;
- (void)addHandler:(id)handle;
//:(void (^)(NSData*))block
-(void) getURL:(NSString *)url;
-(void) postURL:(NSString*)url withData:(NSData*)data;
-(void) account_registerwithAcessToken:(NSString*)accesstoken withNick:(NSString*)nick withPhoto:(NSString*)photo;
-(void) account_auth:(NSString*)accesstoken;
-(void) account_profile_get:(NSString*)sid;
-(void) account_friend_list;
-(void) race_info;
-(void) end;
@end

//
//  NetUtility.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Queue.h"

enum req_type{
    account_register=1,
    account_auth=2,
    
};



@interface NetUtility : NSObject <NSURLConnectionDelegate>
{
    @private NSMutableData* responseData;
    //@private void (^ block)(NSData*);
    
    @private NSMutableArray* arr;
    @private Queue *queue;
    @private NSString *server;
    
}
@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, strong) void (^block)(int, NSDictionary*);
-(id)initwithBlock:(void (^)(int, NSDictionary*))block;

-(void) dealloc;
//:(void (^)(NSData*))block
-(void) getURL:(NSString *)url;
-(void) postURL:(NSString*)url withData:(NSData*)data;
-(void) account_registerwithAcessToken:(NSString*)accesstoken withNick:(NSString*)nick withPhoto:(NSString*)photo;
-(void) account_auth:(NSString*)accesstoken;
-(void) end;
@end

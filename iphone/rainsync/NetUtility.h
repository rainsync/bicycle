//
//  NetUtility.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetUtility : NSObject
{
    @private NSMutableData* responseData;
    @private void (^ block)(NSData*);
    
}
@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, strong) void (^block)(NSData*);
-(void) getURL:(NSString *)url withBlock:(void (^)(NSData*))block;
-(void) postURL:(NSString*)url withData:(NSData*)data withBlock:(void (^)(NSData*))block;

@end

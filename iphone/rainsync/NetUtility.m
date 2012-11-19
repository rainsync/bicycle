//
//  NetUtility.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "NetUtility.h"


@implementation NetUtility

-(id)init{

    //[super init];

    self = [super initWithBaseURL:[NSURL URLWithString:@"http://api.bicy.kr"]];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    self.parameterEncoding = AFJSONParameterEncoding;
    
    

    queue = [[Queue alloc]init];
    fblogin = [[FBLogin alloc] init];
    Session=[self getSession];
    
    return self;
    
}



-(void)dealloc{
    [queue release];
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


-(void) accountRegisterWithFaceBook:(NSString*)accesstoken Withblock:(void(^)(NSDictionary *res, NSError *error))block{
    [self postPath:@"/" parameters:[[[NSDictionary alloc] initWithObjects:@[@"account-register", accesstoken] forKeys:@[@"type",@"accesstoken"]] autorelease]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];

    
}

-(void) accountProfilegGetWithblock:(void(^)(NSDictionary *res, NSError *error))block{
    if(Session){
        [self postPath:@"/" parameters:[[[NSDictionary alloc] initWithObjects:@[@"account-profile-get", Session] forKeys:@[@"type", @"sid"]] autorelease]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil,error);
        }];
    }
}

-(void) accountAuthWith:(NSString*)accesstoken Withblock:(void(^)(NSDictionary *res, NSError *error))block {

    [self postPath:@"/" parameters:[[[NSDictionary alloc] initWithObjects:@[@"account-auth", accesstoken] forKeys:@[@"type", @"accesstoken"]] autorelease]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger state=[[responseObject objectForKey:@"state"] intValue];
        NSString *sessid=[responseObject objectForKey:@"sessid"];
        if(state==0){
            NSLog([NSString stringWithFormat:@"STATE %d SESSION %@", state, sessid]);
            Session = sessid;
            [[NSUserDefaults standardUserDefaults] setObject:Session forKey:@"session"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];


}


-(void) accountFriendListWithblock:(void(^)(NSDictionary *res, NSError *error))block {
    if(Session){
        [self postPath:@"/" parameters:[[[NSDictionary alloc] initWithObjects:@[@"account-friend-list", Session] forKeys:@[@"type", @"sid"]] autorelease]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil,error);
        }];
    }
}


-(void)raceInfoWithblock:(void(^)(NSDictionary *res, NSError *error))block{
    if(Session){
        [self postPath:@"/" parameters:[[[NSDictionary alloc] initWithObjects:@[@"race-info", Session] forKeys:@[@"type", @"sid"]] autorelease] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil,error);
        }];
    }
}

-(void)raceInviteWithtarget:(NSMutableArray *)arr Withblock:(void(^)(NSDictionary *res, NSError *error))block{
    if(Session){
        [self postPath:@"/" parameters:[[[NSDictionary alloc] initWithObjects:@[@"race-invite", Session, arr] forKeys:@[@"type", @"sid", @"targets"]] autorelease] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil,error);
        }];
    }
}

-(void)raceSummaryWithblock:(void(^)(NSDictionary *res, NSError *error))block{
    if(Session){
        [self postPath:@"/" parameters:[[[NSDictionary alloc] initWithObjects:@[@"race-summary", Session] forKeys:@[@"type", @"sid"]] autorelease] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil,error);
        }];
    }
}

-(void)raceRecordWithpos:(NSString*)pos Withblock:(void(^)(NSDictionary *res, NSError *error))block{
    if(Session){
        [self postPath:@"/" parameters:[[[NSDictionary alloc] initWithObjects:@[@"race-record", Session, pos] forKeys:@[@"type", @"sid", @"pos"]] autorelease] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil,error);
        }];
    }
}


-(void)loginFaceBookWithblock:(void(^)(FBSession *session, NSError* error))block
{
    [fblogin openSessionWithAllowLoginUI:TRUE Withblock:block];
}

-(void)RegisterWithFaceBookAndLogin:(void(^)(NSError* error))block
{
    [self loginFaceBookWithblock:^(FBSession *session, NSError *error) {
        if(error){
            block(error);
        }else{
            [self accountRegisterWithFaceBook:session.accessToken Withblock:^(NSDictionary *res, NSError *error) {
                if(error)
                {
                    block(error);
                }else{
                    [self accountAuthWith:session.accessToken Withblock:^(NSDictionary *res, NSError *error) {
                        block(nil);
                    }];
                }
            }];
        }
        
        
    }];
}


@end
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

    
    handler = [[NSMutableArray alloc] init];
    queue = [[Queue alloc]init];
    arr = [[NSMutableArray alloc]init];
    server = @"http://api.bicy.kr";
    Session=nil;
    
    return self;
    
}


- (void)addHandler:(id)handle
{
    [handler addObject:handle];
}

- (void)removeHandler:(id)handle
{
    [handle removeHandler:handle];
}

-(void)dealloc{
    [super dealloc];
    [queue release];
    [arr release];
    
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

-(void) postURL:(NSString*)url withData:(NSData*)data{
    
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [req setHTTPMethod:@"POST"];
    [req setValue:[NSString stringWithFormat:@"%d",[data length]] forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:data];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"connectionDidFinishLoading");


        NSMutableArray *res = JSON;
        for(NSDictionary* dic in res){
            if([queue count]){
                NSNumber *item = [queue pop];
                
                switch ([item intValue]) {
                    case account_register:
                    {
                        NSInteger state=[[dic objectForKey:@"state"] intValue];
                        NSInteger uid=[[dic objectForKey:@"uid"] intValue];
                        NSString *passkey=[dic objectForKey:@"passkey"];
                        NSLog([NSString stringWithFormat:@"STATE %d UID %d PASSKEY %@", state, uid, passkey]);
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
                        }
                        break;
                    }
                }
                        
                for (id handle in handler) {
                    if([handle respondsToSelector:@selector(reqSuccess: withJSON:)])
                        [handle reqSuccess:[item intValue] withJSON:dic];
                }

                [item release];
                
            }
        }

        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"connectionDidFinish Fail Return..");
        for (id handle in handler) {
        if([handle respondsToSelector:@selector(reqFail:)])
            [handle reqFail:error];
        }
        
        
    }];
    [operation setJSONReadingOptions:NSJSONReadingMutableLeaves];
    [operation start];


    
    
}

-(void) account_registerwithAcessToken:(NSString*)accesstoken withNick:(NSString*)nick withPhoto:(NSString*)photo{
    [queue push:[[NSNumber alloc]initWithInt:account_register]];
    [arr addObject:[[[NSDictionary alloc] initWithObjects:@[@"account-register", nick,accesstoken, photo] forKeys:@[@"type", @"nick", @"accesstoken", @"photo"]] autorelease]];
    
}

-(void) account_profile_get:(NSString*)sid{
    [queue push:[[NSNumber alloc]initWithInt:account_profile_get]];
    [arr addObject:[[[NSDictionary alloc] initWithObjects:@[@"account-profile-get", sid] forKeys:@[@"type", @"sid"]] autorelease]];
    
}

-(void) account_auth:(NSString*)accesstoken{

    [queue push:[[NSNumber alloc]initWithInt:account_auth]];
    [arr addObject:[[[NSDictionary alloc] initWithObjects:@[@"account-auth", accesstoken] forKeys:@[@"type", @"accesstoken"]] autorelease]];

}


-(void) account_friend_list{
    
    
    NSString* session = [[Login getInstance] getSession];
    if(session){
    [queue push:[[NSNumber alloc]initWithInt:account_friend_list]];
    [arr addObject:[[[NSDictionary alloc] initWithObjects:@[@"account-friend-list", session] forKeys:@[@"type", @"sid"]] autorelease]];
    }
}


-(void) race_info{
    NSString* session = [[Login getInstance] getSession];
    if(session){
        [queue push:[[NSNumber alloc]initWithInt:race_info]];
        [arr addObject:[[[NSDictionary alloc] initWithObjects:@[@"race-info", session] forKeys:@[@"type", @"sid"]] autorelease]];
    }
}


-(void) end{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONReadingMutableLeaves error:&error];
    [self postURL:server withData:data];
    [arr removeAllObjects];

}

@end
//
//  NetUtility.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "NetUtility.h"


@implementation NetUtility

-(id)initwithHandler:(id)obj{

    
    handler = obj;
    queue = [[Queue alloc]init];
    arr = [[NSMutableArray alloc]init];
    server = @"http://api.bicy.kr";
    
    return self;
    
}

-(void)dealloc{
    [super dealloc];
    [queue release];
    [arr release];
    
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
                if([handler respondsToSelector:@selector(reqSuccess: withJSON:)])
                    [handler reqSuccess:[item intValue] withJSON:dic];
                [item release];
                
            }
        }

        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"connectionDidFinish Fail Return..");
        if([handler respondsToSelector:@selector(reqFail:)])
            [handler reqFail:error];
        
        
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


-(void) end{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONReadingMutableLeaves error:&error];
    [self postURL:server withData:data];
    [arr removeAllObjects];

}

@end
//
//  NetUtility.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "NetUtility.h"



@implementation NetUtility
@synthesize responseData, block;

-(id)initwithBlock:(void (^)(int, NSDictionary*))block{
    responseData = [[[NSMutableData alloc] init] autorelease];
    
    queue = [[Queue alloc]init];
    arr = [[NSMutableArray alloc]init];
    
    server = @"http://api.bicy.kr";
    self.block = block;
    
    return self;
    
}

-(void)dealloc{
    [queue release];
    [super dealloc];
    
}

-(void) getURL:(NSString *)url{
    responseData = [[NSMutableData alloc]init];
    
                    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:req delegate:self];
    //[req release];

    
    
    
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
                self.block([[queue pop] intValue], dic);
            }
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

        NSLog(@"connectionDidFinishLoading");
        NSLog(@"%@",[error localizedDescription]);
        
        
    }];
    [operation setJSONReadingOptions:NSJSONReadingMutableLeaves];
    [operation start];
    [operation release];
    //[req release];

    
    
}

-(void) account_registerwithAcessToken:(NSString*)accesstoken withNick:(NSString*)nick withPhoto:(NSString*)photo{
    [queue push:[[NSNumber alloc]initWithInt:account_register]];
    [arr addObject:[[[NSDictionary alloc] initWithObjects:@[@"account-register", nick,accesstoken, photo] forKeys:@[@"type", @"nick", @"accesstoken", @"photo"]] autorelease]];
    
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
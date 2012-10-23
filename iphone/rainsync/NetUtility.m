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


-(void) getURL:(NSString *)url withBlock:(void (^)(NSData*))block{
    responseData = [[NSMutableData alloc]init];
    
                    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[[NSURLConnection alloc] initWithRequest:req delegate:self]autorelease];
    //[req release];
    self.block = block;
    
    
    
}

-(void) postURL:(NSString*)url withStream:(NSInputStream*)stream withBlock:(void (^)(NSData*))block{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBodyStream:stream];
    [[[NSURLConnection alloc] initWithRequest:req delegate:self] autorelease];
    //[req release];
    self.block = block;
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    self.block(self.responseData);
    
       
    
}


@end

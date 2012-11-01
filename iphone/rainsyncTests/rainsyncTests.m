//
//  rainsyncTests.m
//  rainsyncTests
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "rainsyncTests.h"

@implementation rainsyncTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSLog(@"GG");
    /*
    NetUtility *net =[[NetUtility alloc] init];
    //[net getURL:@"http://api.bicy.kr"];
    
    [net postURL:@"http://api.bicy.kr" withData:[@"[{\"type\":\"test\"},{\"type\":\"test\"},{\"type\":\"test\"}]" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSError *error;

    while(TRUE){
        [[NSRunLoop currentRunLoop] run];
    };
    
    id *test=[NSJSONSerialization JSONObjectWithData:[@"[{\"id\":1},{\"id\":2},{\"id\":3}]" dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    if([test isKindOfClass:[NSMutableArray class]]){
        NSLog(@"AA");
    }else{
        NSLog(@"BB");
    }
    NSDictionary *dic = test[0];
    NSLog(@"gg %@", [dic objectForKey:@"id"]);
    */
    
    STAssertEqualObjects(@"AA", @"BB", @"string", nil);
    STAssertEqualObjects(@"AA", @"AA", @"string", nil);
    //STAssertEqualObjects(1, 1, @"test");
    //STAssertEqualObjects(1, 1, @"test");
    //STAssertEqualObjects(3, 1, @"test");
    //STFail(@"Unit tests are not implemented yet in rainsyncTests");
     
}

@end

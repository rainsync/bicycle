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

- (void)Register
{
    NetUtility *net =[[NetUtility alloc] initwithBlock:^(int msg, NSDictionary * dic) {
        switch(msg){
            case account_register:{
                NSInteger state=[[dic objectForKey:@"state"] intValue];
                NSInteger uid=[[dic objectForKey:@"uid"] intValue];
                NSString *passkey=[dic objectForKey:@"passkey"];
                NSLog([NSString stringWithFormat:@"STATE %d UID %d PASSKEY %@", state, uid, passkey]);
                STAssertEquals(state, 0, @"account-register success", nil);
                break;
            }
                
                
        }
    }];
    
    
    [net account_registerwithAcessToken:@"AAAE46WaL6mcBAN6pnhAW4R5SzdZCd3tEHmnrPquouPkWfjDZAgpx7Atgq9GM1FpaTtGHcseZAKVhe9yIyPmZCUT47cKz5QAZChNVoC4ZCfGgZDZD" withNick:@"KAI" withPhoto:@""];
    [net end];
    
}



- (void)testExample
{

    [self Register];
    
    

    /*
    while(true){
        [[NSRunLoop currentRunLoop] run];
    }
     */
     
}

@end

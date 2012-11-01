//
//  Stack.h
//  rainsync
//
//  Created by xorox64 on 12. 11. 1..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSMutableArray{
    //NSMutableArray *contents;
    
}
- (id) pop;
- (void) push:(id)object;

@end

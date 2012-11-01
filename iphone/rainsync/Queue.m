//
//  Stack.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 1..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "Queue.h"

@implementation Queue



- (id)pop
{
    // nil if [self count] == 0
    id lastObject = [[[self lastObject] retain] autorelease];
    if (lastObject)
        [self removeLastObject];
    return lastObject;
}


- (void)push:(id)obj
{
    [self addObject: obj];
}


@end

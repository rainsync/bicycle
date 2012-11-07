//
//  GroupRideViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *array;
    NSMutableArray *recordings;

}
@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) NSMutableArray *recordings;
@end

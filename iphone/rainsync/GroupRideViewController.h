//
//  GroupRideViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RidingViewController.h"

@interface GroupRideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (retain, nonatomic) IBOutlet UITableView *userTableView;
@property (retain, nonatomic) IBOutlet UIButton *startRdingBtn;
@property (retain, nonatomic) IBOutlet UIButton *inviteUserBtn;

@end

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
@property (nonatomic, retain) IBOutlet UIBarButtonItem *selectButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *inviteButton;

@property (nonatomic, retain) NSMutableArray *selectedUserArray;

@end

//
//  MemberViewController.h
//  rainsync
//
//  Created by 승원 김 on 12. 11. 14..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *myImageView;
@property (retain, nonatomic) IBOutlet UILabel *myNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *mySpeedLabel;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

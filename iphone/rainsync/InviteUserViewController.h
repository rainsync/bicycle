//
//  InviteUserViewController.h
//  rainsync
//
//  Created by 승원 김 on 12. 10. 31..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupRideViewController.h"

@interface InviteUserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (retain, nonatomic) IBOutlet UIButton *BackBtn;
@property (retain, nonatomic) NSArray *listData;
- (IBAction)Back:(id)sender;
@end

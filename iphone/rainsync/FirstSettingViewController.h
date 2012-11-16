//
//  FirstSettingViewController.h
//  rainsync
//
//  Created by 승원 김 on 12. 10. 29..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login.h"
#import "MBProgressHUD.h"
@interface FirstSettingViewController : UIViewController <MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UIButton *fbButton;
@property (retain, nonatomic) IBOutlet UIButton *generalLoginButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (void)viewWillAppear:(BOOL)animated;

@end

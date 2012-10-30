//
//  FirstSettingViewController.h
//  rainsync
//
//  Created by 승원 김 on 12. 10. 29..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FirstSettingViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *fbButton;
@property (retain, nonatomic) IBOutlet UIButton *generalLoginButton;

@property (retain, nonatomic) IBOutlet UIView *selectFbOrGeneralView;
@property (retain, nonatomic) IBOutlet UIView *compeletionSettingView;
- (void)viewWillAppear:(BOOL)animated;

@end

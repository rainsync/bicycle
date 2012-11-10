//
//  ProfileViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetUtility.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *Name;
@property (retain, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) IBOutlet UIView *disableView;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)login:(id)sender;
- (void)editProfile;     // 프로필 수정 함수
@end

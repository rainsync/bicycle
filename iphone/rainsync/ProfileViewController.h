//
//  ProfileViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetUtility.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ProfileViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *Name;
@property (retain, nonatomic) IBOutlet UIImageView *profileImageView;
- (void)editProfile;     // 프로필 수정 함수
@end

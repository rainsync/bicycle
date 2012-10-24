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

@interface ProfileViewController : UIViewController <FBRequestDelegate>
{

    @private FBProfilePictureView* profileview;
    
    
}
@property IBOutlet UIButton* fbloginbutton;
@end

//
//  ViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface ViewController : UIViewController <UITabBarDelegate>
{

    UITabBar* tabBar;
    
    
}
@property (nonatomic, retain) IBOutlet UITabBar* tabBar;


@end

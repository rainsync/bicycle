//
//  ViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray* controllers;
    UITabBar* tabBar;
    UIPageControl* pageControl;
    UIScrollView* scrollView;
    BOOL pageControlUsed;
    
}
@property (nonatomic, retain) IBOutlet UITabBar* tabBar;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

@end

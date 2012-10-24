//
//  RidingViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashBoardViewController.h"
#import "MapViewController.h"


@interface RidingViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray* controllers;
    UIPageControl* pageControl;
    UIScrollView* scrollView;
    @private BOOL pageControlUsed;
    
}
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@end

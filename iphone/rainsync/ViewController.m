//
//  ViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize tabBar;

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog([NSString stringWithFormat:@"test %d", item.tag]);
    
    ProfileViewController* view = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    
    
    //1 프로필 2 떼라 3 라이딩 시작 4 통계 5 설정
    switch(item.tag){
        case 1:
            self.view.
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        case 4:
            
            break;
            
        case 5:
            
            break;
            
    }
    
}

- (void)dealloc {
    [tabBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [tabBar release];
    tabBar = nil;
    [super viewDidUnload];
}
@end

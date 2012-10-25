//
//  GroupRideViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "GroupRideViewController.h"

@interface GroupRideViewController ()

@end

@implementation GroupRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"그룹라이딩";
        
        // Custom initialization
    }
    return self;
}

- (IBAction)ridingChange:(id)sender {
    if(_GroupRiding.on)
        [[NSUserDefaults standardUserDefaults]  setValue:@"Group" forKey:@"RidingType"];
    else
        [[NSUserDefaults standardUserDefaults]  setValue:@"Single" forKey:@"RidingType"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* RidingType = [[NSUserDefaults standardUserDefaults] stringForKey:@"RidingType"];
    if([RidingType isEqualToString:@"Single"])
        [_GroupRiding setOn:FALSE];
    else
        [_GroupRiding setOn:TRUE];
    
        
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_GroupRiding release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setGroupRiding:nil];
    [super viewDidUnload];
}
@end

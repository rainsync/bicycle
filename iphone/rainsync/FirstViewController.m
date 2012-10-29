//
//  FirstViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 26..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)guestEnter:(id)sender {
    
    [[UIApplication sharedApplication] keyWindow].rootViewController=[[ViewController alloc] init];
}

@end

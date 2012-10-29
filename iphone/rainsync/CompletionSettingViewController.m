//
//  CompletionSettingViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 10. 29..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "CompletionSettingViewController.h"
#import "ViewController.h"

@interface CompletionSettingViewController ()

@end

@implementation CompletionSettingViewController

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

- (void)dealloc {
    [_completionBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCompletionBtn:nil];
    [super viewDidUnload];
}
- (IBAction)completeSetting:(id)sender {
    ViewController *viewController = [[ViewController alloc] init];
    [self.view addSubview:viewController.view];
}
@end

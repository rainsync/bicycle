//
//  DetailViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 11. 6..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

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
    [_recordingDay release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setRecordingDay:nil];
    [super viewDidUnload];
}
@end

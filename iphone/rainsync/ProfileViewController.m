//
//  ProfileViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileEditViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"프로필", @"프로필");
        
        // Custom initialization
        
        UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"수정" style: UIBarButtonItemStyleBordered target:self action:@selector(editProfile)];
        self.navigationItem.rightBarButtonItem = edit;
        [edit release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)editProfile {
    ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] initWithNibName:@"ProfileEditViewController" bundle:nil];
    [self.navigationController pushViewController:profileEditViewController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_Name release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setName:nil];
    [super viewDidUnload];
}
@end

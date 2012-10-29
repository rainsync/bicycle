//
//  NameAndAvatarSettingViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 10. 29..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "NameAndAvatarSettingViewController.h"
#import "CompletionSettingViewController.h"

@interface NameAndAvatarSettingViewController ()

@end

@implementation NameAndAvatarSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"내 정보 설정";
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        CGRect r;
        r.origin.x=0;
        r.origin.y=0;
        
        self.navigationController.navigationBar.frame = r;
        
        
        
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
    [_nameTextField release];
    [_cameraRollBtn release];
    [_nextBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setCameraRollBtn:nil];
    [self setNextBtn:nil];
    [super viewDidUnload];
}
- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)callCameraRoll:(id)sender {
}

- (IBAction)goToNextSetting:(id)sender {
    CompletionSettingViewController *completionSettingViewController = [[CompletionSettingViewController alloc] initWithNibName:@"CompletionSettingViewController" bundle:nil];
    [self.view addSubview:completionSettingViewController.view];
}
@end

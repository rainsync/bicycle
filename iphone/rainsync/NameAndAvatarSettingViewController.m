//
//  NameAndAvatarSettingViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 10. 29..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "NameAndAvatarSettingViewController.h"
#import "CompletionSettingViewController.h"
#import "FirstSettingViewController.h"
@interface NameAndAvatarSettingViewController ()

@end

@implementation NameAndAvatarSettingViewController
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //[super initWithRootViewController:self.view];
    
    if (self) {
        // Custom initialization
        self.title = @"내 정보 설정";
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        UIBarButtonItem *prev = [[UIBarButtonItem alloc] initWithTitle:@"이전" style: UIBarButtonItemStyleBordered target:self action:@selector(goToPrevSetting)];
        self.navigationItem.leftBarButtonItem = prev;
        [prev release];
        
        UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"다음" style: UIBarButtonItemStyleBordered target:self action:@selector(goToNextSetting)];
        self.navigationItem.rightBarButtonItem = next;
        [next release];
        
        
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
    self.imageView = nil;
    [super viewDidUnload];
}
- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)goToPrevSetting {
    FirstSettingViewController *firstController = [[FirstSettingViewController alloc]initWithNibName:@"FirstSettingViewController" bundle:nil];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:firstController];
    [firstController release];
    [self.view removeFromSuperview];
    
    
}

- (void)goToNextSetting {
    CompletionSettingViewController *completionSettingViewController = [[CompletionSettingViewController alloc] initWithNibName:@"CompletionSettingViewController" bundle:nil];
    [self.navigationController pushViewController:completionSettingViewController animated:nil];
    
}

#pragma mark -
#pragma mark Camera delegate
- (IBAction)useCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = YES;
    }
}
- (IBAction)callCameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        picker.allowsEditing = NO;
        [self presentModalViewController:picker animated:YES];
        newMedia = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        imageView.image = image;
        if (newMedia) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        }
        else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
            
        }
    }
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" message:@"Failed to save image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


@end

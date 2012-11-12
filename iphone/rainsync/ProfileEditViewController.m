//
//  ProfileEditViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 10. 31..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileEditViewController.h"

@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"내 정보 수정";

        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        UIBarButtonItem *prev = [[UIBarButtonItem alloc] initWithTitle:@"취소" style: UIBarButtonItemStyleBordered target:self action:@selector(cancelAndBack)];
        self.navigationItem.leftBarButtonItem = prev;
        [prev release];
        
        UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"완료" style: UIBarButtonItemStyleBordered target:self action:@selector(saveEditProfile)];
        self.navigationItem.rightBarButtonItem = next;
        [next release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)cancelAndBack;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveEditProfile
{
    
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [_nameTextField resignFirstResponder];
}

#pragma mark -
#pragma mark Camera delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //        imageView.image = image;
        
        // 프로필 사진 버튼의 이미지를 선택된 사진으로 지정
        [_profileImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_profileImageBtn setBackgroundImage:image forState:UIControlStateHighlighted];
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
        [alert release];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


// 프로필사진 터치 시에 액션 시트로 카메라 메뉴 출력
- (IBAction)callCameraAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진촬영", @"앨범에서 사진 선택", @"삭제", nil];
    [actionSheet showInView:self.view];
}

// 액션 시트 이벤트 핸들러
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // 사진 촬영
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
                imagePicker.allowsEditing = NO;
                [self presentModalViewController:imagePicker animated:YES];
                [imagePicker release];
                newMedia = YES;
            }
            break;
        case 1: // 앨범에서 선택하기
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
                picker.allowsEditing = NO;
                [self presentModalViewController:picker animated:YES];
                [picker release];
                newMedia = NO;
            }
            break;
        case 2: // 삭제하기
            [_profileImageBtn setImage:nil forState:UIControlStateNormal];
            [_profileImageBtn setImage:nil forState:UIControlStateHighlighted];
            break;
    }
}

@end

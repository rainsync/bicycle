//
//  ProfileEditViewController.h
//  rainsync
//
//  Created by 승원 김 on 12. 10. 31..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ProfileEditViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    BOOL newMedia;  // 새로운 사진인지 판단하는 불린값
    
    UITextField *bikeNameTextField;
    NSArray *bikeArray;
}

@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UIButton *profileImageBtn;

@property (retain, nonatomic) IBOutlet UIView *bikeSelectView;
@property (retain, nonatomic) IBOutlet UIToolbar *bikeSelectToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *selectBikeBarButton;
@property (retain, nonatomic) IBOutlet UIPickerView *bikeCategoryPickerView;

- (void)cancelAndBack;
- (void)saveEditProfile;

- (IBAction)textFieldDoneEditing:(id)sender;    // 키보드 감추기
- (IBAction)backgroundTap:(id)sender;           // 배경 터치시 키보드 감추기
- (IBAction)callCameraAction:(id)sender;        // 카메라 메뉴 호출
- (IBAction)selectBikeDone:(id)sender;

@end

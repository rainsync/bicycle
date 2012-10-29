//
//  NameAndAvatarSettingViewController.h
//  rainsync
//
//  Created by 승원 김 on 12. 10. 29..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface NameAndAvatarSettingViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL newMedia;
}
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UIButton *cameraRollBtn;
@property (retain, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)useCamera:(id)sender;
- (IBAction)callCameraRoll:(id)sender;
- (IBAction)goToNextSetting:(id)sender;

@end

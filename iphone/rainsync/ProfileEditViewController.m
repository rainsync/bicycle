//
//  ProfileEditViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 10. 31..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "PrettyKit.h"
#import "UIColor+ColorWithHex.h"

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
    
    NSString *bgPath = [[NSBundle mainBundle] pathForResource:@"background@2x.png" ofType:nil];
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:bgPath]];
    [self.tableView setBackgroundView:bview];
    [bview release];
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
    // 저장하는 로직 구현
    [self.navigationController popViewControllerAnimated:YES];
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
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";    
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    // Configure the cell...
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.text = @"Text";
    cell.cornerRadius = 10;
    cell.backgroundColor = [UIColor colorWithHexString:@"0x3f4547"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.borderColor = [UIColor colorWithHexString:@"0x333333"];    
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

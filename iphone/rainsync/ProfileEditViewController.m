//
//  ProfileEditViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 10. 31..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "PrettyKit.h"

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
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:bgPath]];
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return 20;
    }
    if (section == 4) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *SegmentedCellIdentifier = @"SegmentedCell";
    PrettySegmentedControlTableViewCell *segmentedCell;
    static NSString *GridCellIdentifier = @"GridCell";
    PrettyGridTableViewCell *gridCell;
    
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    segmentedCell = [tableView dequeueReusableCellWithIdentifier:SegmentedCellIdentifier];
                    if (segmentedCell == nil) {
                        segmentedCell = [[[PrettySegmentedControlTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SegmentedCellIdentifier] autorelease];
                    }
                    [segmentedCell prepareForTableView:tableView indexPath:indexPath];
                    segmentedCell.titles = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
                    segmentedCell.tableViewBackgroundColor = tableView.backgroundColor;
                    return segmentedCell;
                default:
                    break;
            }
            
            break;
        case 2:
            gridCell = [tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
            if (gridCell == nil) {
                gridCell = [[[PrettyGridTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GridCellIdentifier] autorelease];
                gridCell.tableViewBackgroundColor = tableView.backgroundColor;
                gridCell.actionBlock = ^(NSIndexPath *indexPath, int selectedIndex) {
                    [gridCell deselectAnimated:YES];
                };
            }
            [gridCell prepareForTableView:tableView indexPath:indexPath];
            gridCell.numberOfElements = 3;
            [gridCell setText:@"One" atIndex:0];
            [gridCell setDetailText:@"Detail Text" atIndex:0];
            [gridCell setText:@"Two" atIndex:1];
            [gridCell setDetailText:@"Detail Text" atIndex:1];
            [gridCell setText:@"Three" atIndex:2];
            [gridCell setDetailText:@"Detail Text" atIndex:2];
            return gridCell;
        case 4:
            gridCell = [tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
            if (gridCell == nil) {
                gridCell = [[[PrettyGridTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GridCellIdentifier] autorelease];
                gridCell.tableViewBackgroundColor = tableView.backgroundColor;
                gridCell.actionBlock = ^(NSIndexPath *indexPath, int selectedIndex) {
                    [gridCell deselectAnimated:YES];
                };
            }
            [gridCell prepareForTableView:tableView indexPath:indexPath];
            gridCell.numberOfElements = 2;
            [gridCell setText:@"Four" atIndex:0];
            [gridCell setText:@"Five" atIndex:1];
            return gridCell;
            
        default:
            break;
    }
    
    // Configure the cell...
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.text = @"Text";
    if (indexPath.section == 0) {
        cell.cornerRadius = 20;
    }
    else {
        cell.cornerRadius = 10;
    }
    
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

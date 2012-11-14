//
//  GroupRideViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "GroupRideViewController.h"
#import "PrettyKit.h"

@interface GroupRideViewController ()

@end

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

static NSString *kInvitePartialTitle = @"초대 (%d)";


@implementation GroupRideViewController

- (void) reqSuccess:(int)message withJSON:(NSDictionary *)dic {
    switch (message) {
        case account_friend_list:
        {
            NSInteger state=[[dic objectForKey:@"state"] intValue];
            
            
            if(state==0){
                NSMutableArray *friends=[dic objectForKey:@"friends"];
                for (NSMutableDictionary *dic in friends) {
                    [_selectedUserArray addObject:[dic objectForKey:@"nick"]];
                }
                
                [_userTableView reloadData];
            }
            
            break;
            
        }
        default:
        {
            NSError *error=[NSError errorWithDomain:@"서버로 부터 잘못된 데이터가 전송되었습니다." code:-2 userInfo:nil];
            break;
        }
    }
    
}

- (void)reqFail:(NSError*)error
{
    //[self showError:error];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NetUtility getInstance] addHandler:self];
        // Custom initialization
    }
    return self;
}

- (void) customizeNavBar {
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.topLineColor = [UIColor colorWithHex:0xFF1000];
    navBar.gradientStartColor = [UIColor colorWithHex:0xDD0000];
    navBar.gradientEndColor = [UIColor colorWithHex:0xAA0000];
    navBar.bottomLineColor = [UIColor colorWithHex:0x990000];
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 8;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NetUtility getInstance] account_friend_list];
    [[NetUtility getInstance]end];
    
    _selectedUserArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"구성원 초대";
    self.userTableView.rowHeight = 60;
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.userTableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    self.userTableView.allowsMultipleSelection = YES;  // 복수선택 가능

    [self.userTableView dropShadows];
    [self customizeNavBar];

}
    
- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)onDoneClick:(id)sender
{
    // 선택된 유저 초대 푸쉬 보내고 서버 접속 유도
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_userTableView release];
    [_inviteButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setUserTableView:nil];
    [self setInviteButton:nil];
    [super viewDidUnload];
}

- (IBAction)inviteUser:(id)sender {
    // open a dialog with just an OK button
	NSString *actionTitle = @"선택하신 이용자에게 초대 메세지를 보내시겠습니까?";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
                                                             delegate:self
                                                    cancelButtonTitle:@"아니오"
                                               destructiveButtonTitle:@"네"
                                                    otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];	// show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

#pragma mark -
#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
        NSArray *selectedRows = [self.userTableView indexPathsForSelectedRows];
        if (selectedRows.count > 0)
        {
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                NSLog(@"%d", selectionIndex.row);
            }
        }
    }
    else {
        
    }
}

#pragma mark -
#pragma mark Table view DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_selectedUserArray count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    // 셀 선택 시 하이라이트 효과 해제
    }
    [cell prepareForTableView:tableView indexPath:indexPath];

	cell.textLabel.text = [_selectedUserArray objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    NSString *profile = [[NSBundle mainBundle] pathForResource:@"profile_sample.jpg" ofType: nil];
    cell.imageView.image = [UIImage imageWithContentsOfFile:profile];
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedRows = [self.userTableView indexPathsForSelectedRows];
    NSString *inviteButtonTitle = [NSString stringWithFormat:kInvitePartialTitle, selectedRows.count];
    
    if (selectedRows.count > 0) {
        self.navigationItem.rightBarButtonItem = _inviteButton; // 네비바 오른쪽 버튼 초대버튼 생성
    }
    _inviteButton.title = inviteButtonTitle;

    [self.userTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedRows = [self.userTableView indexPathsForSelectedRows];
    NSString *inviteButtonTitle = [NSString stringWithFormat:kInvitePartialTitle, selectedRows.count];
    [self.userTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;

    if (selectedRows.count != 0) {
        _inviteButton.title = inviteButtonTitle;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


@end

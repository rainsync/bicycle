//
//  ProfileViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileEditViewController.h"
#import "PrettyKit.h"

@implementation ProfileViewController


- (void) reqSuccess:(int)message withJSON:(NSDictionary *)dic {
    switch (message) {
        case account_profile_get:
        {
            NSInteger state=[[dic objectForKey:@"state"] intValue];
            NSString *nick=[dic objectForKey:@"nick"];
            NSString *picture=[dic objectForKey:@"picture"];
            NSString *email=[dic objectForKey:@"email"];
            
            if(state==0){
            [_Name setText:nick];
            [_Email setText:email];
            [_profileImageView setImageWithURL:[[[NSURL alloc] initWithString:picture]autorelease]];    
            NSLog([NSString stringWithFormat:@"STATE %d NICK %@ PICTURE %@ EMAIL %@", state, nick, picture, email]);
            
            
            
                
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
        self.title = NSLocalizedString(@"프로필", @"프로필");
        [[NetUtility getInstance] addHandler:self];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = self.editProfileButton;
    self.editProfileButton.title = @"수정";
    
    NSString *bgPath = [[NSBundle mainBundle] pathForResource:@"background@2x.png" ofType:nil];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:bgPath]];
}

- (IBAction)login:(id)sender {
    
    //[_disableView setHidden:YES];
    [[Login getInstance] join:^{
        [_disableView setHidden:TRUE];
        [[NetUtility getInstance] account_profile_get:[[Login getInstance] getSession]];
        [[NetUtility getInstance] end];
    } withFail:^(NSError *error) {
        [_disableView setHidden:FALSE];
    }];
    
}

- (IBAction)editProfile:(id)sender {
    ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] initWithNibName:@"ProfileEditViewController" bundle:nil];
    [self.navigationController pushViewController:profileEditViewController animated:YES];
    [profileEditViewController release];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *session =[[Login getInstance] getSession];
    if(session)
    {
        
        [[NetUtility getInstance] account_profile_get:session];
        [[NetUtility getInstance] end];
        [_disableView setHidden:TRUE];
        
    }else{
        [_disableView setHidden:FALSE];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_editProfileButton release];
    [_tableView release];
    [super dealloc];
    
    [_Name release];
    [_profileImageView release];
    [_disableView release];
    [_loginButton release];
    [_Email release];

}
- (void)viewDidUnload {
    [self setName:nil];
    [self setProfileImageView:nil];
    [self setDisableView:nil];
    [self setLoginButton:nil];
    [self setEmail:nil];
    [self setEditProfileButton:nil];
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

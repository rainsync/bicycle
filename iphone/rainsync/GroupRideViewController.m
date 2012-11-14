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

@implementation GroupRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"구성원 초대";
    self.userTableView.rowHeight = 60;
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.userTableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil] autorelease];
    
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

- (IBAction)startRiding:(id)sender {

//    RidingViewController *ridingController = [[RidingViewController alloc] initWithNibName:@"RidingViewController" bundle:nil];
    //[self.view.superview addSubview:ridingController.view];
    
  //  [[[UIApplication sharedApplication] keyWindow] setRootViewController:ridingController];
    
    //	self.ridingViewController = ridingController;
//	[self.view insertSubview:ridingController.view atIndex:0];
//    [self.view addSubview:ridingController.view];
//	[ridingController release];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_inviteUserBtn release];
    [_userTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setInviteUserBtn:nil];
    [self setUserTableView:nil];
    [super viewDidUnload];
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
    return 20;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1) {
        static NSString *GridCellIdentifier = @"GridCell";
        
        PrettyGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
        if (cell == nil) {
            cell = [[[PrettyGridTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GridCellIdentifier] autorelease];
            cell.tableViewBackgroundColor = tableView.backgroundColor;
            cell.gradientStartColor = start_color;
            cell.gradientEndColor = end_color;
        }
        cell.numberOfElements = 2;
        [cell setActionBlock:^(NSIndexPath *indexPath, int selectedIndex) {
            [cell deselectAnimated:YES];
        }];
        [cell prepareForTableView:tableView indexPath:indexPath];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        [cell setText:@"Text 1" atIndex:0];
        [cell setText:@"Text 2" atIndex:1];
        [cell setDetailText:@"Subtitle" atIndex:0];
        [cell setDetailText:@"Subtitle" atIndex:1];
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
    }
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.text = @"Text";
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    
    return cell;

}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.userTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

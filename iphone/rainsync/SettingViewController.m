//
//  GroupRideViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "SettingViewController.h"
#import "PrettyKit.h"

#define getNibName(nibName) [NSString stringWithFormat:@"%@%@", nibName, ([UIScreen mainScreen].bounds.size.height == 568)? @"-568":@""]

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"설정";
        // Custom initialization

        UIImage *img = [UIImage imageNamed:@"settingIcon"];
        [self.tabBarItem setImage:img];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:getNibName(@"background")]];
    [_settingTableView setBackgroundView:bview];
    [bview release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titles;
    titles = [NSArray arrayWithObjects:
              @"몸무게",                                      //map
              @"지도 설정",               //location
              nil];
    
    return [titles objectAtIndex:section];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    
    if (section == 0) {
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,0,300,44)];
        headerLabel.backgroundColor= [UIColor clearColor];
        headerLabel.text= [NSString stringWithFormat:@"GPS 설정"];
        headerLabel.font = [UIFont boldSystemFontOfSize:17];
        headerLabel.textColor = [UIColor whiteColor];
        [headerView addSubview: headerLabel];
        [headerLabel release];
    }
    else if (section == 1) {
        UILabel *recordLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,0,300,44)];
        recordLabel.backgroundColor= [UIColor clearColor];
        recordLabel.text=@"GPS 설정";
        recordLabel.font = [UIFont boldSystemFontOfSize:17];
        recordLabel.textColor = [UIColor whiteColor];
        [headerView addSubview: recordLabel];
        [recordLabel release];
    }
    else {
        [headerView setBackgroundColor:[UIColor clearColor]];
    }
    
    return headerView;
}

-(void)cancelNumberPad{
    [text resignFirstResponder];
    text.text = @"";
}

-(void)doneWithNumberPad{
    NSString *numberFromTheKeyboard = text.text;
    [text resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
 
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    // Configure the cell...
    [cell prepareForTableView:tableView indexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"몸무게 설정";
            text = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 20)];
            text.placeholder = @"60 kg";
            [text setKeyboardType:UIKeyboardTypeDecimalPad];
            [text setTextAlignment:NSTextAlignmentRight];
            cell.accessoryView = text;
            
            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
            numberToolbar.barStyle = UIBarStyleBlackTranslucent;
            numberToolbar.items = [NSArray arrayWithObjects:
                                   [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                                   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                                   nil];
            [numberToolbar sizeToFit];
            
            text.inputAccessoryView =numberToolbar;

            //=self;
            
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"GPS 설정";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.textLabel setText:@"주행 중 이동경로 표시"];
                    UIView		*viewCell = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 160, 40)];
                    UISwitch	*drawRouteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(70, 6, 94, 27)];
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"drawRoute"] ) [drawRouteSwitch setOn:YES animated:NO];
                    else [drawRouteSwitch setOn:NO animated:NO];
                    
                    [viewCell addSubview:drawRouteSwitch];
                    [drawRouteSwitch addTarget:self action:@selector(saveRouteOption:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = viewCell;
                    [drawRouteSwitch release];
                    [viewCell		release];
                    break;
            }
            break;
    }

    cell.cornerRadius = 10;
    
    return cell;
}

- (IBAction)saveRouteOption:(id)sender {
    NSLog(@"이동 경로 옵션");
    UISwitch *routeSwitch = (UISwitch *)sender;
	BOOL setting = routeSwitch.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:setting forKey:@"drawRoute"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table view delegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            // 피커뷰 띄워줌
            
            NSLog(@"몸무게 설정");
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    NSLog(@"gps 옵션 설정");
                    break;
                case 1:
                    NSLog(@"주행 중 경로선 옵션 설정");
                    break;
            }
        default:
            break;
    }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}
@end

//
//  GroupRideViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "SettingViewController.h"
#import "PrettyKit.h"

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
        
        _weightArray = [NSArray arrayWithObjects:@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",
                        @"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",
                        @"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",
                        @"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",
                        @"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",
                        @"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",
                        @"100",@"101",@"102",@"103",@"104",@"105",@"106",@"107",@"108",@"109",
                        @"110",@"111",@"112",@"113",@"114",@"115",@"116",@"117",@"118",@"119", nil];
        [_weightArray retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _settingTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

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
            cell.detailTextLabel.text = @"60 kg";
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
            [self showPicker];
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

#pragma mark -
#pragma mark Picker View delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return (NSString*)[_weightArray objectAtIndex:row+1];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_weightArray count] - 1;
}

- (void) showPicker{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"몸무게 설정"
                                                      delegate:self
                                             cancelButtonTitle:@"완료"
                                        destructiveButtonTitle:@"취소"
                                             otherButtonTitles:nil];
    // Add the picker
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,185,0,0)];
    
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;    // note this is default to NO
    
    [menu addSubview:pickerView];
    [menu showInView:self.view];
    [menu setBounds:CGRectMake(0,0,320, 700)];
    
    [pickerView release];
    [menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
}
@end

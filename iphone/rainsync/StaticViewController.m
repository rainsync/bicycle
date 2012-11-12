//
//  GroupRideViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "StaticViewController.h"
#import "DetailViewController.h"
#import "PrettyKit.h"

#define start_color [UIColor colorWithHex:0x646464]
#define end_color [UIColor colorWithHex:0x292929]

@interface StaticViewController ()

@end

@implementation StaticViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"기록";
        
        ridingdb = [[RidingDB alloc] init];
        UIImage *img = [UIImage imageNamed:@"staticIcon"];
        [self.tabBarItem setImage:img];
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        _recordings = [ridingdb loadDB]; // Database loaded
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
    [super dealloc];
    [ridingdb release];
    [_recordings release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        
    [self.tableView dropShadows];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_recordings count];
    NSLog(@"%d", [_recordings count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight + [PrettyCustomViewTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [_recordings objectAtIndex:row];
    cell.textLabel.text = [Utility timeToDate:[[rowData objectForKey:@"start_date"] doubleValue]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:@"singleRiding.png"];    // single, team riding 구분해서 아이콘 달아주기 ; db에 식별자 칼럼 추가?
    

    NSString *recordTime = [Utility getStringTime:[[rowData objectForKey:@"time"] doubleValue] ];;
    // 시간 00:00:00 단위로 변환
    
    double distance = [Utility metreTokilometre:[[rowData objectForKey:@"distance"] doubleValue] ];
    NSString *recordDistance = [NSString stringWithFormat:@"%.1f km", distance];
    // 거리 00.0 단위로 변환
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", recordTime, recordDistance];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6f];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tag = row;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        // Ensure that if the user is editing a name field then the change is committed before deleting a row -- this ensures that changes are made to the correct event object.
		[tableView endEditing:YES];
		
        // Delete the managed object at the given index path.
		
		// Update the array and table view.
        [ridingdb deleteRecord: [[[_recordings objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
        [_recordings removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    if(editing)
    {
        [_tableView setEditing:YES animated:YES];
        NSLog(@"editMode on");
    }
    else
    {
        [_tableView setEditing:NO animated:YES];
        NSLog(@"Done leave editmode");
    }}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
	NSLog(@"didSelectRowAtIndexPath : %d", row);
	NSDictionary *rowData = [_recordings objectAtIndex:row];

    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil WithRawData:rowData];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    detailViewController.title = cell.textLabel.text;
    
    
    
    [detailViewController release];
}

@end
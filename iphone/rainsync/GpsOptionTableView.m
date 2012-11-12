//
//  GpsOptionTableView.m
//  rainsync
//
//  Created by 승원 김 on 12. 11. 12..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "GpsOptionTableView.h"

@interface GpsOptionTableView ()

@end

@implementation GpsOptionTableView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"감도 설정에 따라 배터리소모가 달라질 수 있습니다.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"최상 급";
                break;
            case 1:
                cell.textLabel.text = @"베스트 급";
                break;
            case 2:
                cell.textLabel.text = @"10미터 급";
                break;
            case 3:
                cell.textLabel.text = @"100미터 급";
                break;
            case 4:
                cell.textLabel.text = @"1킬로미터 급";
                break;
            case 5:
                cell.textLabel.text = @"3킬로미터 급";
                break;
        }
    }
    
    // Configure the cell...
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"gps_opt"];
}

@end

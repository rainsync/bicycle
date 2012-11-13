//
//  MemberViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 11. 14..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "MemberViewController.h"
#import "PrettyKit.h"

@interface MemberViewController ()

@end

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

@implementation MemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end

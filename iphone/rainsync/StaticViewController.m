//
//  GroupRideViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "StaticViewController.h"
#import "DetailViewController.h"
#import "RidingDB.h"

@interface StaticViewController ()

@end

@implementation StaticViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"기록";
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    RidingDB *ridingDB = [[RidingDB alloc] init];
    _recordings = [ridingDB loadDB]; // Database loaded
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_recordings count];
    NSLog(@"%d", [_recordings count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [_recordings objectAtIndex:row];
    cell.textLabel.text = [rowData objectForKey:@"id"];
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
	NSLog(@"didSelectRowAtIndexPath : %d", row);
	NSDictionary *rowData = [_recordings objectAtIndex:row];

    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController.recordingTime.text = [rowData objectForKey:@"time"];
    detailViewController.distance.text = [rowData objectForKey:@"distance"];
    detailViewController.averageSpeed.text = [rowData objectForKey:@"speed"];
    detailViewController.altitude.text = [rowData objectForKey:@"altitude"];
    detailViewController.calorie.text = [rowData objectForKey:@"calorie"];
    [detailViewController release];
}

@end
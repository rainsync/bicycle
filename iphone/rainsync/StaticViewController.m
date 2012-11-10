//
//  GroupRideViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "StaticViewController.h"
#import "DetailViewController.h"


@interface StaticViewController ()

@end

@implementation StaticViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"기록";
        
        ridingdb = [[RidingDB alloc] init];


        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
    [super dealloc];
    [ridingdb release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    

    _recordings = [ridingdb loadDB]; // Database loaded
    [self.tableView reloadData];
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
    cell.textLabel.text = [rowData objectForKey:@"day"];
    cell.imageView.image = [UIImage imageNamed:@"singleRiding.png"];    // single, team riding 구분해서 아이콘 달아주기 ; db에 식별자 칼럼 추가?
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

    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    [detailViewController loadView:rowData];
    
    
    [detailViewController release];
}

@end
//
//  MemberViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 11. 14..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "MemberViewController.h"


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
    NSString *bgPath = [[NSBundle mainBundle] pathForResource:@"background-568@2x.png" ofType: nil];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:bgPath]];
    self.tableView.separatorColor = [UIColor blackColor];

        CALayer *layer = [_myImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:30.0];   // 프로필 사진에 레이어를 씌워 라운딩 처리
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ShowMember:(NSMutableArray *)parti
{
    participants = parti;
    [parti retain];
    for (NSMutableDictionary *dic in participants) {
        NSLog(@"%@ ww", [dic objectForKey:@"nick"]);
    }
    if([participants count]){
        [_tableView reloadData];
    }
}

- (void)dealloc {
    [_tableView release];
    [_myImageView release];
    [_myNameLabel release];
    [_mySpeedLabel release];
    [_myView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setMyImageView:nil];
    [self setMyNameLabel:nil];
    [self setMySpeedLabel:nil];
    [self setMyView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [participants count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCustomCell"];
    NSString *light_borderPath = [[NSBundle mainBundle] pathForResource:@"light_border@2x.png" ofType:nil];
    NSString *dark_borderPath = [[NSBundle mainBundle] pathForResource:@"dark_border@2x.png" ofType:nil];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MemberCustomCell" owner:self options:nil];

        for (id oneObject in nib)
			if ([oneObject isKindOfClass:[MemberCustomCell class]])
                cell = (MemberCustomCell *)oneObject;
    }

    

    
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"0x222f38"];    // 밝은쪽 셀
        cell.coverImage.image = [UIImage imageWithContentsOfFile:light_borderPath];
    }
    else {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"0x1a2127"];    // 어두운쪽 셀
        cell.coverImage.image = [UIImage imageWithContentsOfFile:dark_borderPath];
    }
    
        NSLog(@"fff %d",indexPath.row);
    NSMutableDictionary *person = [participants objectAtIndex:indexPath.row];
    
    [cell.memberImage setImageWithURL:[NSURL URLWithString:[person objectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
    cell.memberNumber.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.memberName.text = [person objectForKey:@"nick"];
    cell.memberSpeed.text = @"15.1";
    cell.serverStatus.text = @"접속 중";
    NSString *statusImagePath = [[NSBundle mainBundle] pathForResource:@"bLight.png" ofType: nil];
    cell.serverStatusImage.image = [UIImage imageWithContentsOfFile:statusImagePath];
    
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

@end

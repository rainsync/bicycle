//
//  InviteUserViewController.m
//  rainsync
//
//  Created by 승원 김 on 12. 10. 31..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "InviteUserViewController.h"

@interface InviteUserViewController ()

@end

@implementation InviteUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"구성원 초대", @"구성원 초대");

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *array = [[NSArray alloc] initWithObjects:@"김승원", @"노연재", @"최태양", nil];
    self.listData = array;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.listData objectAtIndex:row];
    return cell;
}


- (void)dealloc {
    [_BackBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBackBtn:nil];
    [super viewDidUnload];
}
- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:FALSE];

//    [UIView beginAnimations:@"back" context:nil];
//	[UIView setAnimationDuration:0.5];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//	
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView: self.view.superview cache:YES];         // forView : 내 뷰의 상위뷰를 넘긴다.
//	[self.view removeFromSuperview];   // 현재의 뷰를 슈퍼뷰에서 제거
//	[UIView commitAnimations];
}
@end

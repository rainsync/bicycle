//
//  GroupRideViewController.h
//  rainsync
//
//  Created by xorox64 on 12. 10. 24..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *settingTableView;
//@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, readonly) NSInteger weight;
@property (nonatomic, retain) NSArray *weightArray;
- (void)setPickerViewValue:(id)value;
- (id)getPickerViewValue;
@end

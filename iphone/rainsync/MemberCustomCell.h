//
//  MemberCustomCell.h
//  rainsync
//
//  Created by 승원 김 on 12. 11. 14..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCustomCell : UITableViewCell {

}
@property (retain, nonatomic) IBOutlet UIImageView *memerImage;
@property (retain, nonatomic) IBOutlet UILabel *memberName;
@property (retain, nonatomic) IBOutlet UILabel *memberSpeed;
@property (retain, nonatomic) IBOutlet UIImageView *serverStatusImage;
@property (retain, nonatomic) IBOutlet UILabel *serverStatus;
@end

//
//  JiaoYiRecordCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/20.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiaoYiRecordCell : UITableViewCell

/**投标人**/
@property (weak, nonatomic) IBOutlet UILabel *name;

/**总额**/
@property (weak, nonatomic) IBOutlet UILabel *amount;

/**投标日期**/
@property (weak, nonatomic) IBOutlet UILabel *date;

/**投标时间**/
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

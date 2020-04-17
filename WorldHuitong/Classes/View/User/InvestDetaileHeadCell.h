//
//  InvestDetaileHeadCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InverstedBiao.h"
@interface InvestDetaileHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**标题**/
@property (weak, nonatomic) IBOutlet UILabel *title;

/**编号**/
@property (weak, nonatomic) IBOutlet UILabel *number;

/**年利率**/
@property (weak, nonatomic) IBOutlet UILabel *rate;

/**预期收益**/
@property (weak, nonatomic) IBOutlet UILabel *expectedReturn;

/**还款方式**/
@property (weak, nonatomic) IBOutlet UILabel *PayMethod;

/**借款期数**/
@property (weak, nonatomic) IBOutlet UILabel *borry_dates;

/**借款时间**/
@property (weak, nonatomic) IBOutlet UILabel *borry_time;

+(instancetype)InvestDetaileHeadCell:(UITableView*)tableView Modle:(InverstedBiao*)biao;

@end

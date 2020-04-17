//
//  InvestFoodCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiaoDate.h"
@interface InvestFoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**期数**/
@property (weak, nonatomic) IBOutlet UILabel *dateNumber;

/**日期**/
@property (weak, nonatomic) IBOutlet UILabel *date;

/**应收金额**/
@property (weak, nonatomic) IBOutlet UILabel *yinShou;

/**实收利息**/
@property (weak, nonatomic) IBOutlet UILabel *shiShouRate;

/**时收本金**/
@property (weak, nonatomic) IBOutlet UILabel *shiShouBenJin;

/**逾期天数**/
@property (weak, nonatomic) IBOutlet UILabel *yuQiData;

/**状态**/
@property (weak, nonatomic) IBOutlet UILabel *stateLable;

+(instancetype)InvestFoodCell:(UITableView*)tableView Modle:(BiaoDate*)biaoDate;


@end

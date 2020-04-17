//
//  MyInvestCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InverstedBiao.h"
@interface MyInvestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**回款状态**/
@property (weak, nonatomic) IBOutlet UILabel *state;

/**标的名称**/
@property (weak, nonatomic) IBOutlet UILabel *name;

/**总收益**/
@property (weak, nonatomic) IBOutlet UILabel *allCount;


/**已收益**/
@property (weak, nonatomic) IBOutlet UILabel *counted;


/**待收益**/
@property (weak, nonatomic) IBOutlet UILabel *counting;


/**时间**/
@property (weak, nonatomic) IBOutlet UILabel *time;


/**总投资**/
@property (weak, nonatomic) IBOutlet UILabel *allInvest;


+(instancetype)MyInvestCell:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath DataArr:(NSArray*)arr;


@end

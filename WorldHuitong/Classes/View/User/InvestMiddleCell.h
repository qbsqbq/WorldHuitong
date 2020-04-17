//
//  InvestMiddleCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InverstedBiao.h"
@interface InvestMiddleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**投资本金**/
@property (weak, nonatomic) IBOutlet UILabel *principal;

/**应收本息**/
@property (weak, nonatomic) IBOutlet UILabel *interest;

/**已赚奖励**/
@property (weak, nonatomic) IBOutlet UILabel *reward;

//查看借款协议
@property (weak, nonatomic) IBOutlet UIButton *checkProtoc;

+(instancetype)InvestMiddleCell:(UITableView*)tableView Modle:(InverstedBiao*)biao;


@end

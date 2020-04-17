//
//  BiaoDate.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/20.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//标期模型

#import <Foundation/Foundation.h>

@interface BiaoDate : NSObject

/**还款期数**/
@property(nonatomic,strong)NSString *recover_period;

/**实还日期**/
@property(nonatomic,strong)NSString *recover_yestime;

/**应收本息**/
@property(nonatomic,strong)NSString *recover_account;

/**计划还款日**/
@property(nonatomic,strong)NSString *recover_time;

/**实还本金**/
@property(nonatomic,strong)NSString *recover_capital_yes;

/**实还利息**/
@property(nonatomic,strong)NSString *recover_interest_yes;

/**逾期天数**/
@property(nonatomic,strong)NSString *late_days;

/**状态**/
@property(nonatomic,strong)NSString *r_status;

/**标的类型**/
@property(nonatomic,strong)NSString *borrow_type;


@end

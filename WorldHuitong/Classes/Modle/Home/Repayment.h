//
//  Repayment.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repayment : NSObject


/**月还款本息**/
@property(nonatomic,strong)NSString *account_all;

/**月还款本金**/
@property(nonatomic,strong)NSString *account_capital;

/**利息**/
@property(nonatomic,strong)NSString *account_interest;

/**余额**/
@property(nonatomic,strong)NSString *account_other;

/**期数**/
@property(nonatomic,strong)NSString *i;

/****/
@property(nonatomic,strong)NSString *repay_month;

/**还款时间**/
@property(nonatomic,strong)NSString *repay_time;





@end

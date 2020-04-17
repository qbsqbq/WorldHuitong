//
//  Biao.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/20.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Biao : NSObject

/**借款标名称**/
@property(nonatomic,strong)NSString *name;

/**借款金额**/
@property(nonatomic,strong)NSString *biao_account;

/**借款进度**/
@property(nonatomic,strong)NSString *borrow_account_scale;

/**年利率**/
@property(nonatomic,strong)NSString *borrow_apr;

/**是否奖励**/
@property(nonatomic,strong)NSString *award_status;

/**奖励金额**/
@property(nonatomic,strong)NSString *award_account;

/**还款期数**/
@property(nonatomic,strong)NSString *recover_period;

/**奖励比例**/
@property(nonatomic,strong)NSString *award_scale;

/**奖励比例**/
@property(nonatomic,assign)float award;

/**借款期限**/
@property(nonatomic,strong)NSString *borrow_period_name;

/**借款标的状态名称**/
@property(nonatomic,strong)NSString *status_type_name;

/**是否已经被锁定0或者空字符串表示未锁定1已锁定**/
@property(nonatomic,strong)NSString *block_status;

/**借款标类型**/
@property(nonatomic,strong)NSString *borrow_type;  //roam-流传标   credit-信用标   pawn-抵押标

/**借款标的nid**/
@property(nonatomic,strong)NSString *borrow_nid;

#pragma 详情属性
/**月还款本息**/
@property(nonatomic,assign)float repay_month_account;

/**还款方式**/
@property(nonatomic,strong)NSString *style_name;

/**可投金额**/
@property(nonatomic,assign)int borrow_account_wait;

/**投资密码**/
@property(nonatomic,strong)NSString *borrow_password;

/**流转标的最小流转金额**/
@property(nonatomic,assign)float account_min;


/**此借款标已投的投资总额**/
@property(nonatomic,assign)float borrow_account_yes;


/**此借款标被投资的次数**/
@property(nonatomic,assign)float tender_times;

/**借款标介绍(普通标)/借款方商业描述(流转标)**/
@property(nonatomic,strong)NSString  *borrow_contents;


@end

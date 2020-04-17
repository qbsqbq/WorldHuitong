//
//  InverstedBiao.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/19.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//我的投资模型

#import <Foundation/Foundation.h>

@interface InverstedBiao : NSObject
/**状态名称**/
@property(nonatomic,strong)NSString *status_type_name;

/**状态标识**/
@property(nonatomic,strong)NSString *borrow_status_nid;

/**借款nid**/
@property(nonatomic,strong)NSString *borrow_nid;

/**借款标题**/
@property(nonatomic,strong)NSString *borrow_name;

/**到期时间**/
@property(nonatomic,assign)int repay_last_time;

/**起息或投资时间(时间戳格式)**/
@property(nonatomic,assign)int addtime;

/**投资记录id**/
@property(nonatomic,assign)int inveterId;

/**总收益**/
@property(nonatomic,assign)float recover_account_all_interest;

/**已收收益**/
@property(nonatomic,assign)float recover_account_all_interest_yes;

/**待收收益**/
@property(nonatomic,assign)float recover_account_all_interest_wait;

/**投资总额**/
@property(nonatomic,assign)float account_tender;

#pragma 详情
/**标题**/
@property(nonatomic,strong)NSString *name;

/**年利率**/
@property(nonatomic,assign)float borrow_apr;

/**预期收益**/
@property(nonatomic,assign)float recover_account_interest;

/**还款方式**/
@property(nonatomic,strong)NSString *style_name;

/**借款期数**/
@property(nonatomic,strong)NSString *borrow_period_name;

/**借款时间**/
@property(nonatomic,strong)NSString *borrow_success_time;


/**借款周期**/
@property(nonatomic,assign)int borrow_period;

/**到期时间**/
//@property(nonatomic,assign)NSString *repay_last_time;


/**最后一期还款时间**/
//@property(nonatomic,strong)NSString *repay_last_time;


/**投资金额**/
@property(nonatomic,assign)float _account;

/**已赚奖励**/
@property(nonatomic,assign)float _award_account;













@end

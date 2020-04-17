//
//  BorrowInfo.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//借款信息

#import <Foundation/Foundation.h>

@interface BorrowInfo : NSObject


/**借款笔数**/
@property(nonatomic,strong)NSString *borrow_loan_num;

/**成功借款笔数**/
@property(nonatomic,strong)NSString *borrow_success_num;

/**还清笔数**/
@property(nonatomic,strong)NSString *repay_yes_times;


/**逾期笔数**/
@property(nonatomic,strong)NSString *repay_late_no_num;


/**借款总额**/
@property(nonatomic,strong)NSString *borrow_success_account;


/**待还**/
@property(nonatomic,strong)NSString *repay_wait_account;


/**逾期金额**/
@property(nonatomic,strong)NSString *repay_late_no_account;



@end

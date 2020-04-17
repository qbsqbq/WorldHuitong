//
//  MoneyNote.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/2.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyNote : NSObject


#pragma 充值

/**充值方式**/
@property(nonatomic,strong)NSString *payment_name;

/**金额**/
@property(nonatomic,strong)NSString *money;

/**充值时间(Unix格式)**/
@property(nonatomic,strong)NSString *addtime;

/**0(审核中)1(充值成功)2(充值失败)**/
@property(nonatomic,strong)NSString *status;



#pragma 提现

/**提现总额**/
@property(nonatomic,strong)NSString *total;

/**到账金额**/
@property(nonatomic,strong)NSString *credited;







@end

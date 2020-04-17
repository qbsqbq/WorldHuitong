//
//  MyBill.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/31.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBill : NSObject

/**资金流动的方向**/
@property(nonatomic,strong)NSString *action_name;

/**资金变动的金额**/
@property(nonatomic,strong)NSString *money;

/**名称**/
@property(nonatomic,strong)NSString *type;

/**余额**/
@property(nonatomic,strong)NSString *balance;

/**备注**/
@property(nonatomic,strong)NSString *remark;

/**时间(时间戳格式)**/
@property(nonatomic,strong)NSString *addtime;


@end

//
//  MyIntegral.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//我的积分

#import <Foundation/Foundation.h>

@interface MyIntegral : NSObject

/**积分数量**/
@property(nonatomic,strong)NSString *value;


/**详细**/
@property(nonatomic,strong)NSString *borrow_name;


/**标题**/
@property(nonatomic,strong)NSString *remark;


/**时间**/
@property(nonatomic,strong)NSString *addtime;


#pragma 消费的积分
/**商品的名称**/
@property(nonatomic,strong)NSString *goods_name;

/**消费的积分**/
@property(nonatomic,strong)NSString *integral;

/**商品的数量**/
@property(nonatomic,strong)NSString *num;





@end

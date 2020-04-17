//
//  MyOrder.h
//  WorldHuitong
//
//  Created by TXHT on 16/9/1.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrder : NSObject
/**时间**/
@property(nonatomic,strong)NSString *addtime;

/**商品名称**/
@property(nonatomic,strong)NSString *goods_name;

/**所用积分**/
@property(nonatomic,strong)NSString *integral;

/**数量**/
@property(nonatomic,strong)NSString *num;

/**商品状态**/
@property(nonatomic,strong)NSString *status;

/**商品图片**/
@property(nonatomic,strong)NSString *thumb;

@end

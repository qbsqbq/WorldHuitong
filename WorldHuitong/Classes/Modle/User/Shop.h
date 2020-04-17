//
//  Shop.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/24.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

/**商品名称**/
@property(nonatomic,strong)NSString *goods_name;

/**商品图片**/
@property(nonatomic,strong)NSString *thumb;

/**商品所需积分数**/
@property(nonatomic,strong)NSString *group_integral;

/**商品市场价**/
@property(nonatomic,strong)NSString *market_price;

/**商品描述**/
@property(nonatomic,strong)NSString *shop_description;

/**商品参数**/
@property(nonatomic,strong)NSString *params;

/**商品id**/
@property(nonatomic,strong)NSString *goods_num;

/**常见问题**/
@property(nonatomic,strong)NSString *question;


@end

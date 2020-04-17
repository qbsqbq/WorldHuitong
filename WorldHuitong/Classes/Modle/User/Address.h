//
//  Address.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/30.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

/**城市**/
@property(nonatomic,strong)NSString *city;

/**收件人**/
@property(nonatomic,strong)NSString *consignee;

/**区**/
@property(nonatomic,strong)NSString *dist;

/**是否设置成默认0-1**/
@property(nonatomic,strong)NSString *is_default;

/**电话**/
@property(nonatomic,strong)NSString *phone;

/**省份**/
@property(nonatomic,strong)NSString *prov;

/**街道**/
@property(nonatomic,strong)NSString *street;

/**邮编**/
@property(nonatomic,strong)NSString *zip_code;

/**ID**/
@property(nonatomic,strong)NSString *ID;



@end

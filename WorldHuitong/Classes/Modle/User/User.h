//
//  User.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/10.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/**邮箱认证状态**/
@property(nonatomic,assign)int email_status;

/**手机认证状态**/
@property(nonatomic,strong)NSString *phone_status;

/**手机号**/
@property(nonatomic,strong)NSString *phone;

/**邮箱**/
@property(nonatomic,strong)NSString *email;

/**用户名**/
@property(nonatomic,strong)NSString *username;

/**vip状态 1是 0否**/
@property(nonatomic,assign)int vip_status;

/**实名认证状态**/
@property(nonatomic,strong)NSString *realname_status;

/**支付密码认证状态**/
@property(nonatomic,assign)int paypassword_status;

/**银行卡认证状态**/
@property(nonatomic,strong)NSString *bank_status;

/**当前用户可用金额**/
@property(nonatomic,assign)float balance;

/**总资产**/
@property(nonatomic,assign)float _total;

/**真实姓名**/
@property(nonatomic,strong)NSString *realname;

/**工作城市**/
@property(nonatomic,strong)NSString *work_city;


@end

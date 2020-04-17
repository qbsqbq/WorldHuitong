//
//  CheckDetaileController.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/31.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Biao.h"

@interface CheckDetaileController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)Biao *biao;
@property(nonatomic,strong)NSString *yuqiIncom;

@property(nonatomic,strong)NSArray *inComes;     //收益数组
@property(nonatomic,strong)NSString *coupon_lixi; //奖金
@property(nonatomic,strong)NSString *lixi;        //利息






@end

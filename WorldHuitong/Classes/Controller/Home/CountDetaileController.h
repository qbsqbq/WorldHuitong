//
//  CountDetaileController.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDetaileController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *replayments;
@property(nonatomic,strong)NSString *repaymentType;       //产品类型
@property(nonatomic,strong)NSString *vcType; //首页或者我要投资页


@end

//
//  BaseInForController.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//基本信息

#import <UIKit/UIKit.h>
#import "User.h"
@interface BaseInForController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)User *user_info;
@property(nonatomic,strong)NSString *borryerName;    //借款人用户名
@property(nonatomic,strong)NSString *borryer_userID; //借款人用户id
@property(nonatomic,strong)NSString *borrow_times;   //发布借款次数

@property(nonatomic,strong)NSString *vcType;


@end

//
//  TenderDetailController.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/8.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Biao.h"
@interface TenderDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)Biao *biao;
@property(nonatomic,strong)NSString *vcType; //首页或者我要投资页


@end

//
//  TouZiController.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetaileBiao.h"
#import "Biao.h"
@interface TouZiController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)DetaileBiao *detaileBiao;
@property(nonatomic,strong)Biao *biao;
@property(nonatomic,strong)NSString *borrow_period_name; //借款时间





@end

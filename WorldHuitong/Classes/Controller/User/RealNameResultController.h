//
//  RealNameResultController.h
//  WorldHuitong
//
//  Created by TXHT on 16/7/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealNameResultController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString *realNameState;
@property(nonatomic,strong)NSString *realName;
@property(nonatomic,strong)NSString *personID;

@end

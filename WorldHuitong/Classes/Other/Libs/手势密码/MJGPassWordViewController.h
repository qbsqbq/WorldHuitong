//
//  MJGPassWordViewController.h
//  HHBank
//
//  Created by 中科金财 on 16/4/7.
//  Copyright © 2016年 SINO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLLockPassword.h"
#import "LLLockViewController.h"

@interface MJGPassWordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>


// 手势解锁相关
@property (strong, nonatomic) LLLockViewController* lockVc; // 添加解锁界面
- (void)pushToLLLockViewController:(LLLockViewType)type;


@end

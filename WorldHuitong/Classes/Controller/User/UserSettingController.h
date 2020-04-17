



//
//  UserSettingController.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/28.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserSettingController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)User *user;
@property(nonatomic,strong)NSString *realName;
@property(nonatomic,strong)NSString *personID;



@end

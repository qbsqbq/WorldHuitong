//
//  BankCardController.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//银行卡认证

#import <UIKit/UIKit.h>

@interface BankCardController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)NSString *realName;
@end

//
//  ModifyBankCardController.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/24.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyBankCardController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)NSString *realName;
@property(nonatomic,strong)NSString *account_all; //全银行卡号
@property(nonatomic,strong)NSString *account;     //部分银行卡号

@property(nonatomic,strong)NSString *bankId;      //银行卡id


@end

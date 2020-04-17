//
//  ModifyBankCarView.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/24.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyBankCarView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_viewH;

@property (weak, nonatomic) IBOutlet UIView *bg_viewF;

/**开户名**/
@property (weak, nonatomic) IBOutlet UILabel *kaihu_name;

/**当前银行卡号**/
@property (weak, nonatomic) IBOutlet UILabel *current_bankCardNo;


/**输入当前银行卡号**/
@property (weak, nonatomic) IBOutlet UITextField *inPut_current_bankCardNo;

/**新银行类型**/
@property (weak, nonatomic) IBOutlet UILabel *bankType;


/**开户所在省**/
@property (weak, nonatomic) IBOutlet UILabel *provinceName;


/**开户所在城市**/
@property (weak, nonatomic) IBOutlet UILabel *cityName;

/**开户行名称**/
@property (weak, nonatomic) IBOutlet UITextField *kaihu_bankName;

/**新银行卡号**/
@property (weak, nonatomic) IBOutlet UITextField *last_bankCarNo;

/**确认新银行卡号**/
@property (weak, nonatomic) IBOutlet UITextField *second_new_bankCardNo;

/**验证码**/
@property (weak, nonatomic) IBOutlet UITextField *inPut_code;

#pragma 方法
/**选择银行类型**/
@property (weak, nonatomic) IBOutlet UIButton *chooseBankTypeBtn;

/**选择省份**/
@property (weak, nonatomic) IBOutlet UIButton *chooseProvinceBtn;

/**选择城市**/
@property (weak, nonatomic) IBOutlet UIButton *chooseCityBtn;

/**发送验证码**/
@property (weak, nonatomic) IBOutlet UIButton *sendCoder;

/**开户名**/
@property (weak, nonatomic) IBOutlet UIButton *sureModifyBtn;


@end

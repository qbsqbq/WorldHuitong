//
//  PhoneView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneView : UIView


@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**手机号码**/
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

/**验证码**/
@property (weak, nonatomic) IBOutlet UITextField *verCode;


/**获取验证码**/
@property (weak, nonatomic) IBOutlet UIButton *getCode;

/**验证按钮**/
@property (weak, nonatomic) IBOutlet UIButton *verify;

@end

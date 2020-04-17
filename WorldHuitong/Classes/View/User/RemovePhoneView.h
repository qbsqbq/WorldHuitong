//
//  RemovePhoneView.h
//  WorldHuitong
//
//  Created by TXHT on 16/7/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemovePhoneView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**验证码**/
@property (weak, nonatomic) IBOutlet UITextField *coderTF;

/**登录密码**/
@property (weak, nonatomic) IBOutlet UITextField *logPsaaWord;

/**获取验证码**/
@property (weak, nonatomic) IBOutlet UIButton *getCoder;

/**解绑按钮**/
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

/**是否显示密码**/
@property (weak, nonatomic) IBOutlet UIButton *loginColoseBtn;

@end

//
//  ForgetView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/11.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_voew;

/**电话号**/
@property (weak, nonatomic) IBOutlet UITextField *phone;

/**验证码**/
@property (weak, nonatomic) IBOutlet UITextField *verCoder;

/**密码**/
@property (weak, nonatomic) IBOutlet UITextField *passWord;

/**获取验证码**/
@property (weak, nonatomic) IBOutlet UIButton *getVerCorder;

/**确认**/
@property (weak, nonatomic) IBOutlet UIButton *comited;

/**眼睛**/
@property (weak, nonatomic) IBOutlet UIButton *eyesBtn;



@end

//
//  LogView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/10.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogView : UIView
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**用户名/手机号**/
@property (weak, nonatomic) IBOutlet UITextField *phone;

/**密码**/
@property (weak, nonatomic) IBOutlet UITextField *passWoord;

/**记住密码**/
@property (weak, nonatomic) IBOutlet UIButton *remberPw;

/**登陆**/
@property (weak, nonatomic) IBOutlet UIButton *logIn;

/**忘记密码**/
@property (weak, nonatomic) IBOutlet UIButton *forgetPw;

/**注册**/
@property (weak, nonatomic) IBOutlet UIButton *regiestBtn;

/**眼睛**/
@property (weak, nonatomic) IBOutlet UIButton *eyesBtn;



@end

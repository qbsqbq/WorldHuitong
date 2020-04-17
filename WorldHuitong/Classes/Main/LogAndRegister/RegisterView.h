//
//  RegisterView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_viewTop;
@property (weak, nonatomic) IBOutlet UIView *bg_viewMiddle;


/**选择注册方式**/
@property (weak, nonatomic) IBOutlet UIButton *chooseRegWay;

/**注册方式**/
@property (weak, nonatomic) IBOutlet UILabel *regWay;

/**电话号码**/
@property (weak, nonatomic) IBOutlet UITextField *phone;

/**验证码**/
@property (weak, nonatomic) IBOutlet UITextField *VerCode;

/**获取验证码按钮**/
@property (weak, nonatomic) IBOutlet UIButton *getVerCode;

/**密码**/
@property (weak, nonatomic) IBOutlet UITextField *passWord;

/**推荐人**/
@property (weak, nonatomic) IBOutlet UITextField *Referral;

/**同意协议**/
@property (weak, nonatomic) IBOutlet UIButton *shure;

/**协议地址**/
@property (weak, nonatomic) IBOutlet UIButton *delegateUrl;

/**立即注册**/
@property (weak, nonatomic) IBOutlet UIButton *liJiRegisted;


+(instancetype)registerView;




@end

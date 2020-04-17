//
//  emailView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/6.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface emailView : UIView
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**邮件地址**/
@property (weak, nonatomic) IBOutlet UITextField *email;

/**密码**/
@property (weak, nonatomic) IBOutlet UITextField *passWord;


/**推荐人**/
@property (weak, nonatomic) IBOutlet UITextField *referral;

/**同意协议 **/
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;


/**协议地址 **/
@property (weak, nonatomic) IBOutlet UIButton *delegateUrl;

/**立即注册**/
@property (weak, nonatomic) IBOutlet UIButton *regiesterBtn;


@end

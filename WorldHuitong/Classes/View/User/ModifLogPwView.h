//
//  ModifLogPwView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifLogPwView : UIView

/**原始登陆密码**/
@property (weak, nonatomic) IBOutlet UITextField *oldPw;

/**新密码**/
@property (weak, nonatomic) IBOutlet UITextField *lastPw;

/**确认新密码**/
@property (weak, nonatomic) IBOutlet UITextField *shurePw;

/**确认修改按钮**/
@property (weak, nonatomic) IBOutlet UIButton *shureModif;



@end

//
//  MyIntegralView.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/2.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIntegralView : UIView

/**所有积分**/
@property (weak, nonatomic) IBOutlet UILabel *all_integral;

/**可用积分**/
@property (weak, nonatomic) IBOutlet UILabel *can_integral;

/**积分明细按钮**/
@property (weak, nonatomic) IBOutlet UIButton *jifenDetaiBtn;

/**赚积分按钮**/
@property (weak, nonatomic) IBOutlet UIButton *zhuanJifenBtn;

/**积分兑换lable**/
@property (weak, nonatomic) IBOutlet UILabel *jifenHuanLable;

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**用户头像**/
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

/**用户名称**/
@property (weak, nonatomic) IBOutlet UILabel *userName;

/**是否vip用户**/
@property (weak, nonatomic) IBOutlet UIImageView *isVip;








@end

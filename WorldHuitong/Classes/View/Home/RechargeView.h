//
//  RechargeView.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/13.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeView : UIView

/**类型名称**/
@property (weak, nonatomic) IBOutlet UILabel *title;

/**textFild的背景view**/
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**textFild**/
@property (weak, nonatomic) IBOutlet UITextField *textField;

/**注意**/
@property (weak, nonatomic) IBOutlet UILabel *alterTitle;

/**网银充值银行限额参考表**/
@property (weak, nonatomic) IBOutlet UIButton *wangYingTableBtn;


/**确认提交安妮按钮**/
@property (weak, nonatomic) IBOutlet UIButton *submit;

-(RechargeView*)initRview:(UIViewController*)vc Button:(UIButton *)tempBtn;


@end

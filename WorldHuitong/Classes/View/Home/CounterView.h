//
//  CounterView.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/13.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterView : UIView
/**背景view**/
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**借款金额**/
@property (weak, nonatomic) IBOutlet UITextField *borrowedMoney;

/*产品类型**/
@property (weak, nonatomic) IBOutlet UITextField *pType;

/**输入天数**/
@property (weak, nonatomic) IBOutlet UITextField *inPutDay;

/**选择产品类型按钮**/
@property (weak, nonatomic) IBOutlet UIButton *prodcTypeBtn;

/**年化率**/
@property (weak, nonatomic) IBOutlet UITextField *nianReta;

/**还款方式**/
@property (weak, nonatomic) IBOutlet UILabel *repayment;

/**还款方式按钮**/
@property (weak, nonatomic) IBOutlet UIButton *repaymentTypeBtn;

/**还款方式按钮的箭头**/
@property (weak, nonatomic) IBOutlet UIButton *jaintou;

/**开始计算按钮**/
@property (weak, nonatomic) IBOutlet UIButton *startCount;

#pragma *******计算结果*********
/**计算结果背景view**/
@property (weak, nonatomic) IBOutlet UIView *bg_result;

/**查看明细lable**/
@property (weak, nonatomic) IBOutlet UILabel *detail;

/**每个月将偿还**/
@property (weak, nonatomic) IBOutlet UILabel *monthRepay;

/**每个月将偿还lable**/
@property (weak, nonatomic) IBOutlet UILabel *mothRepayLable;


/**月利率**/
@property (weak, nonatomic) IBOutlet UILabel *monthrRete;

/**月利率lable**/
@property (weak, nonatomic) IBOutlet UILabel *mothrReteLable;

/**还款本息总额**/
@property (weak, nonatomic) IBOutlet UILabel *amount;

/**查看明细**/
@property (weak, nonatomic) IBOutlet UIButton *detaileBtn;

@property (weak, nonatomic) IBOutlet UILabel *tian;







@end

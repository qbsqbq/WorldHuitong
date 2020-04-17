//
//  BankCardView.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_viewH;

@property (weak, nonatomic) IBOutlet UIView *bg_viewF;



/**开户名**/
@property (weak, nonatomic) IBOutlet UILabel *kaiHu_userName;

/**银行卡号**/
@property (weak, nonatomic) IBOutlet UITextField *bankCarNo;


/**开户银行**/
@property (weak, nonatomic) IBOutlet UILabel *bankName;


/**开户省**/
@property (weak, nonatomic) IBOutlet UILabel *privense;


/**开户市**/
@property (weak, nonatomic) IBOutlet UILabel *cityName;


/**开户行名称**/
@property (weak, nonatomic) IBOutlet UITextField *kaihu_bankName;


/**选择开户银行按钮**/
@property (weak, nonatomic) IBOutlet UIButton *chooseBankBtn;

/**选择省份按钮**/
@property (weak, nonatomic) IBOutlet UIButton *choosePricenseBtn;


/**选择城市按钮**/
@property (weak, nonatomic) IBOutlet UIButton *chooseCityBtn;

/**确认按钮**/
@property (weak, nonatomic) IBOutlet UIButton *shureBtn;







@end

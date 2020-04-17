//
//  TouZiView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouZiView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**可投资lable**/
@property (weak, nonatomic) IBOutlet UILabel *canInvestLable;

/**投资额度**/
@property (weak, nonatomic) IBOutlet UILabel *investMoney;

/**份或者元**/



/**份或者元**/
@property (weak, nonatomic) IBOutlet UILabel *fenOryuan;


/**可投资份数**/
@property (weak, nonatomic) IBOutlet UILabel *canInvestNumber;

/**投资份数**/
@property (weak, nonatomic) IBOutlet UITextField *investNumber;

/**减份数**/
@property (weak, nonatomic) IBOutlet UIButton *subAction;

/**加份数**/
@property (weak, nonatomic) IBOutlet UIButton *addAction;

/**收益**/
@property (weak, nonatomic) IBOutlet UILabel *income;

/**查看明细**/
@property (weak, nonatomic) IBOutlet UIButton *detailsAction;

/**投资密码**/
@property (weak, nonatomic) IBOutlet UITextField *invsetPw;

/**立即投资**/
@property (weak, nonatomic) IBOutlet UIButton *LiJiInvest;












@end

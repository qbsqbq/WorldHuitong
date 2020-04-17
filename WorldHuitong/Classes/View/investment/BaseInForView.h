//
//  BaseInForView.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseInForView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_viewH;

@property (weak, nonatomic) IBOutlet UIImageView *user_icon;

@property (weak, nonatomic) IBOutlet UILabel *user_address;


@property (weak, nonatomic) IBOutlet UILabel *user_name;

@property (weak, nonatomic) IBOutlet UIImageView *reamName;

@property (weak, nonatomic) IBOutlet UIImageView *email;


@property (weak, nonatomic) IBOutlet UIImageView *phone;


@property (weak, nonatomic) IBOutlet UIView *bg_viewF;

/**发布借款**/
@property (weak, nonatomic) IBOutlet UILabel *faBuBorry;

/**成功借款**/
@property (weak, nonatomic) IBOutlet UILabel *borryed;

/**还清笔数**/
@property (weak, nonatomic) IBOutlet UILabel *huanQing;

/**逾期笔数**/
@property (weak, nonatomic) IBOutlet UILabel *yuQiNumber;

/*借款总额**/
@property (weak, nonatomic) IBOutlet UILabel *total_account;

/**待还金额**/
@property (weak, nonatomic) IBOutlet UILabel *daihuan_money;

/**逾期金额**/
@property (weak, nonatomic) IBOutlet UILabel *yuqi_money;



@end

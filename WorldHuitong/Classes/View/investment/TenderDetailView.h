//
//  TenderDetailView.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/8.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Biao.h"
@interface TenderDetailView : UIView

/**中间的线**/
@property (weak, nonatomic) IBOutlet UILabel *lable;

/**年化率**/
@property (weak, nonatomic) IBOutlet UILabel *scale;

/**理财期限**/
@property (weak, nonatomic) IBOutlet UILabel *timeLimit;

/**项目总额**/
@property (weak, nonatomic) IBOutlet UILabel *rental;

/**进度线条的背景**/
@property (weak, nonatomic) IBOutlet UIView *progressScale;

/**进度线条**/
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


/**已融资比例**/
@property (weak, nonatomic) IBOutlet UILabel *inancedScale;

/**可售金额**/
@property (weak, nonatomic) IBOutlet UILabel *vendibilityMoney;

/**起投金额**/
@property (weak, nonatomic) IBOutlet UILabel *staryMoney;

/**购买次数**/
@property (weak, nonatomic) IBOutlet UILabel *buyTimes;

/**起息时间**/
@property (weak, nonatomic) IBOutlet UILabel *dateOfValue;

/**还款方式**/
@property (weak, nonatomic) IBOutlet UILabel *modeOfRepayment;

/**资金到帐**/
@property (weak, nonatomic) IBOutlet UILabel *ZiJinDaoZhang;
@property (weak, nonatomic) IBOutlet UIView *bg_regBtnBotton;

/**按钮上面的背景色**/
@property (weak, nonatomic) IBOutlet UIView *bg_buttonHead;

#pragma 四个lable的属性
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;
@property (weak, nonatomic) IBOutlet UILabel *lable4;

@property (weak, nonatomic) IBOutlet UIView *bg_allButton;

/**查看详细还款时间**/
@property (weak, nonatomic) IBOutlet UIButton *lookDetaile;


 /**基本信息按钮**/
@property (weak, nonatomic) IBOutlet UIButton *asicInfo;

/**借款标介绍按钮**/
@property (weak, nonatomic) IBOutlet UIButton *introduce;

 /**项目材料按钮**/
@property (weak, nonatomic) IBOutlet UIButton *material;

 /**交易记录按钮**/
@property (weak, nonatomic) IBOutlet UIButton *transaction;

/**设置cell上的属性**/
-(void)setViewAttribute;

/**注册**/
@property (weak, nonatomic) IBOutlet UIButton *regBtb;

+(instancetype)tenderDelViewWithModle:(Biao*)modle;
@end

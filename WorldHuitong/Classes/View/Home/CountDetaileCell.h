//
//  CountDetaileCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repayment.h"
@interface CountDetaileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**期数**/
@property (weak, nonatomic) IBOutlet UILabel *dataNumber;

/**时间**/
@property (weak, nonatomic) IBOutlet UILabel *time;

/**月还款本息**/
@property (weak, nonatomic) IBOutlet UILabel *monthBenXi;

/**月还款本息lable**/
@property (weak, nonatomic) IBOutlet UILabel *monthBenXiLable;

/**月还款本金**/
@property (weak, nonatomic) IBOutlet UILabel *monthBenJIn;
/**月还款本金lable**/
@property (weak, nonatomic) IBOutlet UILabel *monthBenJinLable;


/**利息**/
@property (weak, nonatomic) IBOutlet UILabel *lixi;


/**余额**/
@property (weak, nonatomic) IBOutlet UILabel *yue;

+(instancetype)CountDetaileCellWithModle:(Repayment*)modle RepaymentText:(NSString *)repaymentText;




@end

//
//  MyBillCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/31.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**资金流动的方向**/
@property (weak, nonatomic) IBOutlet UILabel *actionName;


/**资金变动的金额**/
@property (weak, nonatomic) IBOutlet UILabel *account;


/**备注**/
@property (weak, nonatomic) IBOutlet UILabel *renark_account;

/**图片**/
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;


/**时间**/
@property (weak, nonatomic) IBOutlet UILabel *time;




@end

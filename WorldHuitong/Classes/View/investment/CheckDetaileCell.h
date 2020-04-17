//
//  CheckDetaileCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/31.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckDetaileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**收款日期**/
@property (weak, nonatomic) IBOutlet UILabel *shou_data;


/**类型**/
@property (weak, nonatomic) IBOutlet UILabel *money_type;


/**收款金额**/
@property (weak, nonatomic) IBOutlet UILabel *shou_account;



/**收款日期**/




@end

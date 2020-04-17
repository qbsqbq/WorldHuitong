//
//  CheckDetaileView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/31.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckDetaileView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_viewf;

/**借款期限**/
@property (weak, nonatomic) IBOutlet UILabel *qixian;

/**含利息**/
@property (weak, nonatomic) IBOutlet UILabel *lixi;

/**含奖金**/
@property (weak, nonatomic) IBOutlet UILabel *bonus;

///**收款日**/
//@property (weak, nonatomic) IBOutlet UILabel *shou_time;
//
//
/**类型**/
//@property (weak, nonatomic) IBOutlet UILabel *type_mponey;
//
///**收款金额**/
//@property (weak, nonatomic) IBOutlet UILabel *account;



@end

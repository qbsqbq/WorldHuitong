//
//  MyIntegralCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/2.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIntegralCell : UITableViewCell

/**积分来源**/
@property (weak, nonatomic) IBOutlet UILabel *integral_type;

/**详情来源**/
@property (weak, nonatomic) IBOutlet UILabel *detail_sorse;


/**积分数量**/
@property (weak, nonatomic) IBOutlet UILabel *integtal_number;


/**积分来源**/

@end

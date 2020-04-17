//
//  MyRecommendCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/6.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecommendCell : UITableViewCell


/**推荐的朋友**/
@property (weak, nonatomic) IBOutlet UILabel *myfriend;


/**是否投资**/
@property (weak, nonatomic) IBOutlet UILabel *istouzi;

/**奖励**/
@property (weak, nonatomic) IBOutlet UILabel *jiangli;

@end

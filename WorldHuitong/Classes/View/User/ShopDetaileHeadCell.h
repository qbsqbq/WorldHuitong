//
//  ShopDetaileHeadCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/24.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shop.h"

@interface ShopDetaileHeadCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *shopicon;

@property (weak, nonatomic) IBOutlet UILabel *shopName;


@property (weak, nonatomic) IBOutlet UILabel *jifenNum;

@property (weak, nonatomic) IBOutlet UILabel *marktPrice;

@property (weak, nonatomic) IBOutlet UIView *lineLable;

+(instancetype)shopDetaileHeadCellWithModle:(Shop*)modle;
@end

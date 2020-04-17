//
//  OrderFillCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shop.h"
@interface OrderFillCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *jifen;

@property (weak, nonatomic) IBOutlet UILabel *marketPrice;

@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
+ (instancetype)orderFillCellWithModle:(Shop*)modle;

@end

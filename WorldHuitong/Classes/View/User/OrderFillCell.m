//
//  OrderFillCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "OrderFillCell.h"
#import "UIImageView+WebCache.h"
@implementation OrderFillCell

+ (instancetype)orderFillCellWithModle:(Shop*)modle {
    OrderFillCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderFillCell" owner:self options:nil]lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (modle) {
        NSString *image = [NSString stringWithFormat:@"%@%@",kBaseImageUrl,modle.thumb];
            [cell.shopIcon sd_setImageWithURL:[NSURL URLWithString:image]];
        cell.shopName.text = modle.goods_name;
        NSString *jifenText = [NSString stringWithFormat:@"%@ 积分",modle.group_integral];
        cell.jifen.attributedText = [HTView setLableColorText:jifenText loc:2 Color:[UIColor lightGrayColor]FontOfSize:12];
        cell.marketPrice.text = [NSString stringWithFormat:@"市场参考价格:%@",modle.market_price];
    }else{
    
    }
        
    return cell;
  }



@end

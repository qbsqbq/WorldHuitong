//
//  ShopDetaileHeadCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/24.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "ShopDetaileHeadCell.h"
#import "UIImageView+WebCache.h"
@implementation ShopDetaileHeadCell

+(instancetype)shopDetaileHeadCellWithModle:(Shop*)modle
{
    ShopDetaileHeadCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopDetaileHeadCell" owner:self options:nil] lastObject];
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kBaseImageUrl,modle.thumb];
    [cell.shopicon sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    cell.shopicon.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.shopName.text = modle.goods_name;
    if (modle.group_integral) {
        NSString *price = [NSString stringWithFormat:@"%@ 积分",modle.group_integral];;
        cell.jifenNum.attributedText = [HTView setLableColorText:price loc:2 Color:[UIColor darkGrayColor]FontOfSize:12];
        cell.marktPrice.text = [NSString stringWithFormat:@"市场参考价：%@元",modle.market_price];
    }
    
    cell.lineLable.backgroundColor = HT_BG_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

@end

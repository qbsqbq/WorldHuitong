//
//  HomeRecommendCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/6.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#define krecommendCell @"HomeRecommendCell"
#import "HomeRecommendCell.h"

@implementation HomeRecommendCell


+(instancetype)RecommendCellWith:(UICollectionView*)collectionView IndexPath:(NSIndexPath*)indexPath Modle:(Biao*)modle
{
    HomeRecommendCell *cell = (HomeRecommendCell*)[collectionView dequeueReusableCellWithReuseIdentifier:krecommendCell forIndexPath:indexPath];
    
    //比例圈
    [[HTView shareHTView] progressWithFram:CGRectMake(0, 0, 40, 40) OnView:cell.bg_progress Percent:[modle.borrow_account_scale floatValue] Animation:NO];
    
    //标的类型
    cell.typeIcon.image = [UIImage imageNamed:modle.borrow_type];
    
    //名称
    cell.title.text = modle.name;
    
    //利息
    cell.rate.textColor = HT_COLOR;
    if (modle.borrow_type != nil) {
        NSString *rate = [[ NSString stringWithFormat:@"%.2f", [modle.borrow_apr floatValue] ] stringByAppendingString:@"%"];
        cell.rate.attributedText = [[HTView shareHTView] setLableAttriText:rate];
    }else{
        cell.rate.text =  @"";
    }
    
    //周期
    if (modle.borrow_period_name) {
        cell.time.text = [NSString stringWithFormat:@"%@",modle.borrow_period_name];
    }else{
        cell.time.text = [NSString stringWithFormat:@""];
    }
    
    
    //总额
    if ([modle.biao_account floatValue] >= 10000.00) {
        cell.totalAmount.text = [NSString stringWithFormat:@"￥%.2f万",[modle.biao_account floatValue]  / 10000];
    }else {
        cell.totalAmount.text = [NSString stringWithFormat:@"￥%.f元",[modle.biao_account floatValue] ];
    }
    
    
    return cell;

}


@end

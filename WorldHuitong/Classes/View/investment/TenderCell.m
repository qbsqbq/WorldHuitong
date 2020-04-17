//
//  TenderCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/21.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "TenderCell.h"

@implementation TenderCell


-(instancetype)tenderCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath Modle:(Biao*)biao
{
    static NSString *ID = @"TenderCell";
    TenderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:4];
    
    //借款进度
    if([biao.borrow_account_scale floatValue] < 100.00)
    {
        [[HTView shareHTView] progressWithFram:CGRectMake(0, 0, 34, 34) OnView:cell.bg_progress Percent:[biao.borrow_account_scale floatValue] Animation:NO];
    }else{
        _icon_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
        _icon_imageView.image = [UIImage imageNamed:@"huan_icon"];
        [cell.bg_progress addSubview:_icon_imageView];
    }

    //名称
    cell.title.text = biao.name;
    
    //借款金额
    if ([biao.biao_account floatValue] >= 10000) {
        cell.totalAmount.text = [NSString stringWithFormat:@"%.2f万",[biao.biao_account floatValue] / 10000];
        
    }else{
        
        cell.totalAmount.text = [NSString stringWithFormat:@"%.2f",[biao.biao_account floatValue]];
    }
  
    //年利率
    NSString *strRate = [[NSString stringWithFormat:@"%@",biao.borrow_apr] stringByAppendingString:@"%"];
    cell.rate.attributedText = [[HTView shareHTView] setLableAttriText:strRate];
   
    //借款期限
    cell.time.text = biao.borrow_period_name;
    
    //标的类型图片
    cell.typeIcon.image = [UIImage imageNamed:biao.borrow_type];

    
    return cell;
}


















@end

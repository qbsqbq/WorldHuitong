//
//  NewBiaotiyanCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "NewBiaotiyanCell.h"

@implementation NewBiaotiyanCell

+(instancetype)newBiaotiyancellWith:(UITableView *)tableView {
    NewBiaotiyanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headCell"];
    
    cell.lijiBuy.backgroundColor = HT_COLOR;
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:3];
    [[HTView shareHTView]setView:cell.lijiBuy cornerRadius:3];
    cell.biao_reta.attributedText = [[HTView shareHTView]setLableAttriText:@"12.00%"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

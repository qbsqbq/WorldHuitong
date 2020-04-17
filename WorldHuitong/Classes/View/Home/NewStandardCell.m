//
//  NewStandardCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/16.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "NewStandardCell.h"
#import "NSString+Category.h"
@implementation NewStandardCell
+(instancetype)newStandardCellWith:(UICollectionView*)collectionView IndexPath:(NSIndexPath*)indexPath Modle:(NewBiao*)modle
{
    NewStandardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewStandardCell" forIndexPath:indexPath];
    
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:3];
    
    if (modle.name) {
        
        NSString *apr = [modle.borrow_apr stringByAppendingString:@"%"];
        cell.nianReta.attributedText = [[HTView shareHTView] setLableAttriText:apr];
        cell.biaoName.text = modle.name;
        cell.qixian.text = modle.borrow_period_name;
    }

    return cell;

}


@end

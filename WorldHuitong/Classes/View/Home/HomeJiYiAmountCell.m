//
//  HomeJiYiAmountCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/16.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "HomeJiYiAmountCell.h"

@implementation HomeJiYiAmountCell


+(instancetype)homeJiYiAmountCellWith:(UICollectionView*)collectionView IndexPath:(NSIndexPath*)indexPath Amount:(NSString*)amount Lixi:(NSString *)lixi
{
    
    HomeJiYiAmountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeJiYiAmountCell" forIndexPath:indexPath];
    
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:3];

    if (lixi != nil) {
        cell.jiaoyiAmount.attributedText = [HTView setLableColorText:amount loc:1 Color:[UIColor blackColor]FontOfSize:12];
        cell.allLixi.attributedText = [HTView setLableColorText:lixi loc:1 Color:[UIColor blackColor]FontOfSize:12];
        
    }

    return cell;


}
@end

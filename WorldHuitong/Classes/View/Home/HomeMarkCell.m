//
//  HomeMarkCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/6.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//
#define kHomeMarkCell @"HomeMarkCell"

#import "HomeMarkCell.h"

@implementation HomeMarkCell

+(instancetype)MarkCellWith:(UICollectionView*)collectionView IndexPath:(NSIndexPath*)indexPath titleArr:(NSArray*)tarr ImageArr:(NSArray *)iarr
{
    HomeMarkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeMarkCell forIndexPath:indexPath];
    cell.title.text = tarr[indexPath.row];
    cell.detaileTitle.text = @[@"礼包免费领",@"天下汇通介绍",@"风控更安心",@"积分兑换"][indexPath.row];
    cell.icon.image = [UIImage imageNamed:iarr[indexPath.row]];
    
    return cell;

}


@end

//
//  UseHeadCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "UseHeadCell.h"

@implementation UseHeadCell


+(instancetype)UseHeadCellWithCollectionView:(UICollectionView*)collectionView ID:(NSString *)ID IndexPath:(NSIndexPath*)indexPath Modle:(User*)modle Interest:(NSString *)interest
{
    UseHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //总资产
    if (modle._total >= 10000) {
        cell.totalAssets.text = [NSString stringWithFormat:@"%.2f万",modle._total / 10000];

    }else{
        cell.totalAssets.text = [NSString stringWithFormat:@"%.2f",modle._total];
    }
    
    //我的收益
    if (!kUSER_ID) {
        cell.earnings.text = @"0.00";
    }else {
        cell.earnings.text = interest;

    }
    
    //可用余额
    cell.availableBalance.text = [NSString stringWithFormat:@"%.2f",modle.balance];
    [[NSUserDefaults standardUserDefaults]setFloat:modle.balance forKey:@"balance"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return cell;

}

@end

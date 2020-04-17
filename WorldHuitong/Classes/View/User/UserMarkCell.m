//
//  UserMarkCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "UserMarkCell.h"

@implementation UserMarkCell

+(instancetype)UserMarkCellCollectionView:(UICollectionView*)collectionView Identifier:(NSString*)identifier IndexPath:(NSIndexPath*)indexPath Titles:(NSArray *)titles Icons:(NSArray*)icon
{
    UserMarkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.title.text = titles[indexPath.row];
    cell.icon.image = [UIImage imageNamed:icon[indexPath.row]];
    
    if (indexPath.section == 1) {
        if (!indexPath.row == 0 || !(indexPath.row + 1)% 3 != 0) {
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    
    return cell;


}


@end

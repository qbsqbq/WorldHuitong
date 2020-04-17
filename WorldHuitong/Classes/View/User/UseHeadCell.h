//
//  UseHeadCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface UseHeadCell : UICollectionViewCell
/**总资产**/
@property (weak, nonatomic) IBOutlet UILabel *totalAssets;

/**我的收益**/
@property (weak, nonatomic) IBOutlet UILabel *earnings;

/**可用余额**/
@property (weak, nonatomic) IBOutlet UILabel *availableBalance;


+(instancetype)UseHeadCellWithCollectionView:(UICollectionView*)collectionView ID:(NSString *)ID IndexPath:(NSIndexPath*)indexPath Modle:(User*)modle Interest:(NSString *)interest;


@end

//
//  HomeJiYiAmountCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/16.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeJiYiAmountCell : UICollectionViewCell
+(instancetype)homeJiYiAmountCellWith:(UICollectionView*)collectionView IndexPath:(NSIndexPath*)indexPath Amount:(NSString*)amount Lixi:(NSString *)lixi;

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**累计交易额**/
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiAmount;

/**累计产生利息**/
@property (weak, nonatomic) IBOutlet UILabel *allLixi;


@end

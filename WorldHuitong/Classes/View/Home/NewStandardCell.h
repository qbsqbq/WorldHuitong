//
//  NewStandardCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/16.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewBiao.h"

@interface NewStandardCell : UICollectionViewCell

+(instancetype)newStandardCellWith:(UICollectionView*)collectionView IndexPath:(NSIndexPath*)indexPath Modle:(NewBiao*)modle;

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**标的的名称**/
@property (weak, nonatomic) IBOutlet UILabel *biaoName;

/**标的的类型**/
@property (weak, nonatomic) IBOutlet UIImageView *iconType;

/**期限**/
@property (weak, nonatomic) IBOutlet UILabel *qixian;

/**立即购买按钮**/
@property (weak, nonatomic) IBOutlet UIButton *lijigoumai;

/**年化率**/
@property (weak, nonatomic) IBOutlet UILabel *nianReta;


@end

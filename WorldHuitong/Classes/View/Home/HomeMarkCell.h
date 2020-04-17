//
//  HomeMarkCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/6.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMarkCell : UICollectionViewCell
/**入口的图标**/
@property (weak, nonatomic) IBOutlet UIImageView *icon;

/**标题**/
@property (weak, nonatomic) IBOutlet UILabel *title;

/**详细**/
@property (weak, nonatomic) IBOutlet UILabel *detaileTitle;


+(instancetype)MarkCellWith:(UICollectionView*)collectionView IndexPath:(NSIndexPath*)indexPath titleArr:(NSArray*)tarr ImageArr:(NSArray *)iarr;
@end

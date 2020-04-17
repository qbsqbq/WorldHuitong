//
//  UserMarkCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMarkCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *bottonLine;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;

/**标签的图片**/
@property (weak, nonatomic) IBOutlet UIImageView *icon;

/**标签的名称**/
@property (weak, nonatomic) IBOutlet UILabel *title;


+(instancetype)UserMarkCellCollectionView:(UICollectionView*)collectionView Identifier:(NSString*)identifier IndexPath:(NSIndexPath*)indexPath Titles:(NSArray *)titles Icons:(NSArray*)icon;


@end

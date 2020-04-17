//
//  ImageBrowseCollectionViewCell.h
//  ImageBrowse
//
//  Created by CheMiMacPro on 15/7/8.
//  Copyright (c) 2015年 CheMiMacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageBrowseModel.h"

@interface ImageBrowseCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *imageView;

- (void)updateCellWithModel:(ImageBrowseModel *)model;


@end

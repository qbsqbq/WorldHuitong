//
//  ImageBrowseCollectionViewCell.m
//  ImageBrowse
//
//  Created by CheMiMacPro on 15/7/8.
//  Copyright (c) 2015年 CheMiMacPro. All rights reserved.
//

#import "ImageBrowseCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageBrowseCollectionViewCell ()<UIScrollViewDelegate>


@end

@implementation ImageBrowseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatViewsWithFrame:(CGRect)frame];
    }
    return self;
}

- (void)creatViewsWithFrame:(CGRect)frame
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 3;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:_imageView];
    [self.contentView addSubview:_scrollView];
    
}

- (void)updateCellWithModel:(ImageBrowseModel *)model
{
    _scrollView.zoomScale = 1;
    if (model.imageUrl) {
        if ([model.imageUrl hasPrefix:@"http://"] || [model.imageUrl hasPrefix:@"https://"]) {
            [_imageView setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
        }else{
            //------------------------根据图片的url反取图片－－－－－
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            NSURL *url=[NSURL URLWithString:model.imageUrl];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                ALAssetRepresentation* representation = [asset defaultRepresentation];
                UIImage *image=[UIImage imageWithCGImage:representation.fullScreenImage];
                _imageView.image=image;
            }failureBlock:^(NSError *error) {
//                NSLog(@"error=%@",error);
            }];
        }
    }
    
    if (model.image) {
        _imageView.image = model.image;
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;

    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [_imageView setCenter:CGPointMake(xcenter, ycenter)];
    
}

@end

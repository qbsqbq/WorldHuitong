//
//  ImageBrowseViewController.h
//  ImageBrowse
//
//  Created by CheMiMacPro on 15/7/8.
//  Copyright (c) 2015年 CheMiMacPro. All rights reserved.
//相册

#import <UIKit/UIKit.h>

@interface ImageBrowseViewController : UIViewController


- (instancetype)initWithBrowseImages:(NSArray *)images withIndex:(NSInteger)index;
- (instancetype)initWithBrowseImages:(NSArray *)images withIndex:(NSInteger)index withTitle:(NSString *)title;

@end

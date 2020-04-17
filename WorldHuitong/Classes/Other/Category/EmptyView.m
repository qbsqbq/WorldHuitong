//
//  EmptyView.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame] ) {

    } ;
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Image:(NSString*)igName
{

    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:igName];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = image;
        imageView.frame = CGRectMake(0, self.bounds.size.height / 2 - image.size.height, kScreenWidth, image.size.height);
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + image.size.height, kScreenWidth, 30)];
        titleLable.text = title;
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.textColor = RGBA_COLOR(70, 70, 70, 1);
        titleLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:imageView];
        [self addSubview:titleLable];
    }
    return self;
}

@end

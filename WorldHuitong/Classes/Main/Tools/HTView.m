//
//  HTView.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/6.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "HTView.h"

@implementation HTView

+(HTView *)shareHTView
{
    static HTView *_htVeiw = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
       
        _htVeiw = [[self alloc]init];
    });
    return _htVeiw;

}

-(UIView *)emptView
{
    if (_emptView != nil) {
        _emptView = [[UIView alloc]init];
    }
    return _emptView;

}
-(UIImageView*)getImageViewWithImage:(NSString *)imageName
{
    //设置导航栏图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 30.0f)];//初始化图片视图控件
    imageView.contentMode = UIViewContentModeScaleAspectFit;//设置内容样式,通过保持长宽比缩放内容适应视图的大小,任何剩余的区域的视图的界限是透明的。
    UIImage *image = [UIImage imageNamed:imageName];//初始化图像视图
    [imageView setImage:image];
    return imageView;

}

-(void)progressWithFram:(CGRect)rect OnView:(UIView*)view Percent:(CGFloat)precent Animation:(BOOL)animation
{
    self.circleView = [[KNCirclePercentView alloc]initWithFrame:rect];
    [self.circleView drawPieChartWithPercent:precent
                                    duration:0.0
                                   clockwise:YES
                                   fillColor:[UIColor clearColor]
                                 strokeColor:[UIColor orangeColor]
                              animatedColors:@[[UIColor orangeColor],
                                                          HT_COLOR]];
    self.circleView.percentLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:self.circleView];
//    if (animation) {
//        [self.circleView startAnimation];
//    }else {
//    
//    }

}

-(void)setView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
{
    view.layer.cornerRadius = cornerRadius;
    [view.layer setShadowOffset:CGSizeMake(0.5, 0.5)];
    [[view layer] setShadowColor:[[UIColor lightGrayColor] CGColor]];
    view.alpha = 0.9;
    [[view layer] setShadowOpacity:1.0];
    [[view layer] setMasksToBounds:NO];
    [[view layer] setShadowRadius:1.0];

}


-(NSMutableAttributedString*)setLableAttriText:(NSString *)text
{
    NSMutableAttributedString *atext = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",text]];
    [atext beginEditing];
    [atext addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange([text length] - 1, 1)];
    return atext;
}

-(void)setStatusBarBg:(UINavigationController *)nav
{
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, 20)];
    statusBarView.image = [UIImage imageNamed:@"ht_na_bg"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [nav.navigationBar addSubview:statusBarView];
}

+(void)navigationBarBgImage:(UINavigationController*)navigationController Image:(NSString *)imageName
{
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:imageName] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.translucent = NO;  //控制透明度的开关
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


+(void)alterTitle:(NSString *)title
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alter show];

}

+(void)alterTitle:(NSString *)title WithTimer:(NSTimeInterval)timer
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alter show];
}

+(NSMutableAttributedString*)setLableColorText:(NSString *)text loc:(NSInteger)loc Color:(UIColor*)color FontOfSize:(CGFloat)size
{
    NSMutableAttributedString *atext = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",text]];
    [atext beginEditing];
    
     [atext addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange([text length] - loc, loc)];
    [atext addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange([text length] - loc,loc)];
    return atext;
}


+(void)isWiffOnView:(UIView*)view
{
    BOOL isReach = [Tools isConnectionAvailable];
    if (isReach) {
    }else{
        [[Tools shareTools]progressWithTitle:@"网络连接已断开" Image:kFimage OnView:view Hide:2];
        
    }
}

-(void)addEmptiViewOn:(UITableView *)tableView type:(NSString *)imageName fram:(CGRect)fram Title:(NSString *)title
{
    self.emptView = [[UIView alloc]initWithFrame:fram];
    [tableView addSubview:self.emptView];
    
    self.emptView.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    imageView.frame = CGRectMake(0, self.emptView.bounds.size.height / 2 - image.size.height, kScreenWidth, image.size.height);
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + image.size.height, kScreenWidth, 30)];
    titleLable.text = title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = RGBA_COLOR(70, 70, 70, 1);
    titleLable.font = [UIFont systemFontOfSize:15];
    [self.emptView addSubview:titleLable];
    [self.emptView addSubview:imageView];
}

-(void)hidenEmptView
{
    self.emptView.hidden = YES;

}
@end

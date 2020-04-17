//
//  HTView.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/6.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNCirclePercentView.h"

@interface HTView : UIView
@property(nonatomic,retain)KNCirclePercentView*circleView;
@property(nonatomic,retain)UIView *emptView;


+(HTView *)shareHTView;

/**根据image的名字返回一个imageView**/
-(UIImageView*)getImageViewWithImage:(NSString *)imageName;

/**根据一个比例值画出一个饼状图**/
-(void)progressWithFram:(CGRect)rect OnView:(UIView*)view Percent:(CGFloat)precent Animation:(BOOL)animation;

/**设置view的边框**/
-(void)setView:(UIView *)view cornerRadius:(CGFloat)cornerRadius;

/**设置lable最后一个字符的大小不同**/
-(NSMutableAttributedString*)setLableAttriText:(NSString *)text;

/**设置状态栏的背景颜色为HT_COLOR**/
-(void)setStatusBarBg:(UINavigationController *)nav;

/**一个快速弹窗**/
+(void)alterTitle:(NSString *)title;

+(void)alterTitle:(NSString *)title WithTimer:(NSTimeInterval)timer;

/**设置导航栏的图片**/
+(void)navigationBarBgImage:(UINavigationController*)navigationController Image:(NSString *)imageName;

/**设置lable的后几位颜色不同**/
+(NSMutableAttributedString*)setLableColorText:(NSString *)text loc:(NSInteger)loc Color:(UIColor*)color FontOfSize:(CGFloat)size;

/**判断网络**/
+(void)isWiffOnView:(UIView*)view;

/**给空的tableView添加的占位图片**/
-(void)addEmptiViewOn:(UITableView *)tableView type:(NSString *)imageName fram:(CGRect)fram Title:(NSString *)title;

/**删除占位图片**/
-(void)hidenEmptView;


@end

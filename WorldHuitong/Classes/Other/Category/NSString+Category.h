//
//  NSString+Category.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)
/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
-(CGFloat)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**字符串的编码/转义**/
- (NSString *)URLEncodedString;


+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end

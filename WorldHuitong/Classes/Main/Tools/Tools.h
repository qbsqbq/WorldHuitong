//
//  Tools.h
//  网上银行
//
//  Created by TXHT on 16/3/29.
//  Copyright © 2016年 天下汇通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface Tools : NSObject
/** 创建单利 **/
+(Tools*)shareTools;

/** 判断是否联网 **/
+(BOOL)isConnectionAvailable;

/** 添加加载等待视图 **/
-(void)progressWithTitle:(NSString *)title OnView:(UIView*)view;

/** 添加提示视图 **/
-(void)progressWithTitle:(NSString *)title Image:(NSString *)imgName OnView:(UIView*)view Hide:(NSTimeInterval)timeInterval;

/** 隐藏加载等待视图 **/
-(void)hidenHud;

/** 创建一个空白的view **/
-(UIImageView*)emptyWithImage:(NSString*)imName;

/** 配置afn **/
-(AFHTTPSessionManager*)afn;

/**MD5加密一个字符串**/
-(NSString *)md5:(NSString*)str;

/**将一个dic装转变成一个json字符串**/
-(NSString*)dictionaryToJson:(NSDictionary *)dic;

/**给参数拼接特定字符串**/
-(NSString *)htstr:(NSString *)par;

/**生成一个六位数的随机数**/
+(NSString *)arc;

/**返回用户的ID**/
+(NSNumber*)HtUserId;

/**返回字符串的utf8编码值**/
+(NSString *)utf8:(NSString *)string;

/**返回一个标准的时间格式**/
+(NSString*)dateFormatter:(int)dateInter;

/**返回一个标准的时间格式只有年月日**/
+(NSString*)dateFormatterShort:(int)dateInter;


//提示
+(void)alterWithTitle:(NSString *)title;

//获取验证码倒计时
+(void)startTime:(UIButton *)_l_timeButton;


/**
 *  正则表达式
 */

//手机号码验证
+ (BOOL) isMobile:(NSString *)mobileNumbel;

//中国邮政编码为6位数字
+ (BOOL)isPost:(NSString*)postNumber;


@end





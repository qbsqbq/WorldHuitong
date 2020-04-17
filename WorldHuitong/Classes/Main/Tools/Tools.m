//
//  Tools.m
//  网上银行
//
//  Created by TXHT on 16/3/29.
//  Copyright © 2016年 天下汇通. All rights reserved.
//

#import "Tools.h"
@implementation Tools
{
    MBProgressHUD *_hud;
    UIImageView *_empty;

}

//创建单利
+(Tools *)shareTools{
    static Tools *_tools = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _tools = [[self alloc]init];
    });
    
    return _tools;
}


+(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    if (!isExistenceNetwork) {
        
        return NO;
    }
    return isExistenceNetwork;
}

-(void)progressWithTitle:(NSString *)title OnView:(UIView*)view
{
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.label.text = title;
    _hud.animationType = MBProgressHUDAnimationZoom;
    _hud.square = YES;
   
}

-(void)progressWithTitle:(NSString *)title Image:(NSString *)imgName OnView:(UIView*)view Hide:(NSTimeInterval)timeInterval
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:timeInterval];
    
}


-(void)hidenHud{
 
    [_hud hideAnimated:YES];
}


-(UIImageView*)emptyWithImage:(NSString *)imName
{
    
    if (!_empty) {
        _empty = [[UIImageView alloc]init];
        _empty.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64);
        _empty.image = [UIImage imageNamed:imName];
    }
    return _empty;
}


-(AFHTTPSessionManager*)afn{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    return manager;
}


-(NSString *)md5:(NSString*)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str,(CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16 ; i ++)
        [hash appendFormat:@"%02x",result[i]];
    
    return [hash lowercaseString] ;
}

-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONReadingMutableLeaves error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


-(NSString *)htstr:(NSString *)par
{
    return  [NSString stringWithFormat:@"%@huitongp2p",par];

}


+(NSString *)arc{

    NSString *arcNumber = @"";

    for (int i = 0; i < 6; i ++) {
        arcNumber = [arcNumber stringByAppendingFormat:@"%i",(arc4random()%9)];
    }
    return arcNumber;
}

+(NSNumber*)HtUserId
{
    int userId =[[[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"] intValue];
    NSNumber *ID = [NSNumber numberWithInt:userId];
    return ID;
}


+(NSString *)utf8:(NSString *)string
{
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


+(NSString*)dateFormatter:(int)dateInter
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy/MM/dd/ HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dateInter];
    NSString *dateString = [formatter stringFromDate:confromTimesp];

    return dateString;
}

+(NSString*)dateFormatterShort:(int)dateInter
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dateInter];
    NSString *dateString = [formatter stringFromDate:confromTimesp];
    
    return dateString;
}
//声明一个网络请求的block
-(void)requestWithDic:(NSDictionary *)dic
{
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
    } fail:^(NSError *error) {

        
    }];

}


+(void)alterWithTitle:(NSString *)title
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alter show];
}

//获取验证码倒计时
+(void)startTime:(UIButton *)_l_timeButton
{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                [_l_timeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                _l_timeButton.userInteractionEnabled = YES;
                _l_timeButton.backgroundColor = HT_COLOR;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_l_timeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                _l_timeButton.backgroundColor = [UIColor lightGrayColor];
                _l_timeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}


 + (BOOL)isPost:(NSString*)postNumber
{
    NSString* number = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:postNumber];
}

@end

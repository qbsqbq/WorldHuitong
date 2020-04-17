//
//  LLLockPassword.m
//  LockSample
//
//  Created by Lugede on 14/11/12.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockPassword.h"

@implementation LLLockPassword

#pragma mark - 锁屏密码读写
+ (NSString*)loadLockPassword
{
    NSString *pswd = [[NSUserDefaults standardUserDefaults] objectForKey:@"lock"];
    if (pswd != nil && ![pswd isEqualToString:@""] && ![pswd isEqualToString:@"(null)"]) {
        
//        NSLog(@"pswd xx = %@", pswd);
        return pswd;
    }
    
    return nil;
}

//存储密码
+ (void)saveLockPassword:(NSString*)pswd
{
    [[NSUserDefaults standardUserDefaults] setObject:pswd forKey:@"lock"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 是否需要提示输入密码
+ (BOOL)isAlreadyAskedCreateLockPassword
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* pswd = [ud objectForKey:@"AlreadyAsk"];
    
    if (pswd != nil && [pswd isEqualToString:@"YES"]) {
        
        return NO;
    }
    
    return NO;
}

// 需要提示过输入密码了
+ (void)setAlreadyAskedCreateLockPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"AlreadyAsk"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//********************************************************************************
//我的存储
+ (NSString *)setLockPassWordTag
{
    [[NSUserDefaults standardUserDefaults] setObject:@"create" forKey:@"tag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return nil;
}
//我的读取
+ (NSString *)getLockPassWordTag
{
    [[NSUserDefaults standardUserDefaults] setObject:@"create" forKey:@"tag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return nil;
}
//我的删除
+ (NSString *)removeLockPassWordTag
{
    [[NSUserDefaults standardUserDefaults] setObject:@"create" forKey:@"tag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return nil;
}
//********************************************************************************



@end

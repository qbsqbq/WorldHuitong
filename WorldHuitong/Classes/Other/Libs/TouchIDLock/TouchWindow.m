//
//  TouchWindow.m
//  TouchIDDemo
//
//  Created by Ben on 16/3/11.
//  Copyright © 2016年 https://github.com/CoderBBen/YBTouchID.git. All rights reserved.
//

#import "TouchWindow.h"
#import <LocalAuthentication/LAContext.h>
#import "BackGrouadController.h"
#import "ForgetController.h"
#import "LogController.h"
@interface TouchWindow ()

@property (nonatomic, strong) UIAlertAction *confirmAction;
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) LAContext *context;

@end

@implementation TouchWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [BackGrouadController new];
    }
    
    return self;
}

-(void)openTouchIdAction
{
    [self alertEvaluatePolicyWithTouchID];
}

//出现
- (void)show
{

    //获取通知中心单例对象---（点击指纹界面的按钮再次打开指纹解锁）
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者
    [center addObserver:self selector:@selector(openTouchIdAction) name:@"openTouchId" object:nil];

    //
    [self makeKeyAndVisible];
    self.hidden = NO;
    [self alertEvaluatePolicyWithTouchID];
}


//消失
- (void)dismiss
{
    [self resignKeyWindow];
    self.hidden = YES;
}

//解锁成功，图片动画
- (void)imageViewShowAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.rootViewController.view.alpha = 0;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
            
        } completion:^(BOOL finished) {
            [self.rootViewController.view removeFromSuperview];
            [self dismiss];
        }];
    });
}

//开启指纹
- (void)alertEvaluatePolicyWithTouchID
{
    [_alert dismissViewControllerAnimated:YES completion:nil];
    self.rootViewController = [BackGrouadController new];
    _context = [LAContext new];
    NSError *error;
    //Whether the device support touch ID? ---if it's yes,support!Otherwise,the system version is lower than iOS8.
    if([_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        
//        NSLog(@"Yeah,Support touch ID");
        
        //if return yes,whether your fingerprint correct.
        [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                //解锁成功
                [self imageViewShowAnimation];
            }
            else
            {
                //不支持，输入密码
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertViewWithEnterPassword:YES];
                });
//                NSLog(@"fail");
            }
        }];
    }
    else
    {
    
        //验证失败，输入密码
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertViewWithEnterPassword:YES];
        });
        [HTView alterTitle:@"对不起，设备不支持touch ID"];
    }
    
}

//if it is not support touch ID,then input password
- (void)alertViewWithEnterPassword:(BOOL)isTrue
{
    if (isTrue)
    {
        _alert = [UIAlertController alertControllerWithTitle:@"输入密码" message:@"请输入您的登陆密码" preferredStyle:UIAlertControllerStyleAlert];
    }
    else
    {
        _alert = [UIAlertController alertControllerWithTitle:@"密码错误" message:@"再次输入您的登陆密码" preferredStyle:UIAlertControllerStyleAlert];
    }
    
    
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"找回密码" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_alert.textFields.firstObject];
        
        //开启指纹
//        [self alertEvaluatePolicyWithTouchID];
        
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(toHomeVC:) name:@"toHomeVC" object:nil];
        
        //找回密码
        ForgetController *logVC = [[ForgetController alloc]init];
        [self.rootViewController presentViewController:logVC animated:YES completion:nil];

    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_alert.textFields.firstObject];
        NSString *appLogPW = [[NSUserDefaults standardUserDefaults]objectForKey:@"log_passWord"];
        if ([_alert.textFields.firstObject.text isEqualToString:appLogPW])   //app登陆密码
        {
            [self imageViewShowAnimation];
        }
        else
        {
            [self alertViewWithEnterPassword:NO];
        }
    }];
    
    confirmAction.enabled = NO;
    self.confirmAction = confirmAction;
    __weak typeof(self)weakSelf = self;
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(alertTextFieldChangeTextNotificationHandler:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [_alert addAction:backAction];
    [_alert addAction:confirmAction];
    
    [self.rootViewController presentViewController:_alert animated:YES completion:nil];
}

- (void)alertTextFieldChangeTextNotificationHandler:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    self.confirmAction.enabled = textField.text.length > 5;
}

-(void)toHomeVC:(NSNotification*)notifcation
{
    [self.rootViewController.view removeFromSuperview];
    [self dismiss];
    
#pragma ----找回密码成功，删除关闭指纹解锁进入-----
    
    //1.关闭指纹解锁
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"OntouchId"];
    
    //2.去掉记住的密码和账号
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"log_userName"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"log_passWord"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"remeber_log_PassWord"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    //3.创建一个消息对象-（找回密码成功，立即发送通知，让首页进入登陆界面）
    NSNotification * notice = [NSNotification notificationWithName:@"toLogVC" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
   
    
}

@end

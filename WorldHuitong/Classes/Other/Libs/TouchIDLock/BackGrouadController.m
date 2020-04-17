//
//  BackGrouadController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/12.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "BackGrouadController.h"
#import "LogController.h"
#import "TouchWindow.h"
#import "AppDelegate.h"
@interface BackGrouadController ()
@property (weak, nonatomic) IBOutlet UIButton *touchIdBtn;

@end

@implementation BackGrouadController

- (void)viewDidLoad {

    [super viewDidLoad];

}

- (IBAction)touchAgain:(id)sender {

    //通知-再次开启指纹解锁
    NSNotification * notice = [NSNotification notificationWithName:@"openTouchId" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
}



//指纹解锁-登陆其他账号
- (IBAction)LogOtherUser:(UIButton *)sender {
    
    
}



@end

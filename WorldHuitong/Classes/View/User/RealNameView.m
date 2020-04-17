//
//  RealNameView.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RealNameView.h"

@implementation RealNameView

+(instancetype)realNameView
{
    RealNameView *head = [[[NSBundle mainBundle]loadNibNamed:@"RealNameView" owner:self options:nil] lastObject];
    head.submit.backgroundColor = [UIColor lightGrayColor];
    
    head.zhu.text = @"注：\n1.我们将通过全国公民身份信息中心(NCIIC)系统对您提交的身份进行审核。\n2.实名认证是您绑定银行卡和使用核心功能的必要条件。\n3.请填写您的真实姓名及身份证号，您所填写的资料均为保密，请您放心填写。";
    [[HTView shareHTView]setView:head.submit cornerRadius:4];
 
    return head;

}

@end

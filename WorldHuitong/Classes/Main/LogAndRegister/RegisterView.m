//
//  RegisterView.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView


+(instancetype)registerView
{
    RegisterView *head = [[[NSBundle mainBundle]loadNibNamed:@"RegisterView" owner:self options:nil]lastObject];
    head.liJiRegisted.backgroundColor = HT_COLOR;
    [[HTView shareHTView]setView:head.liJiRegisted cornerRadius:4];
    [[HTView shareHTView]setView:head.bg_viewTop cornerRadius:4];
    [[HTView shareHTView]setView:head.bg_viewMiddle cornerRadius:4];
    [[HTView shareHTView]setView:head.getVerCode cornerRadius:0];
    

    return  head;
}

@end

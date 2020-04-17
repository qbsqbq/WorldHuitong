//
//  RechargeView.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/13.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RechargeView.h"

@implementation RechargeView

-(RechargeView*)initRview:(UIViewController*)vc Button:(UIButton *)tempBtn
{
    RechargeView *headView = [[[NSBundle mainBundle] loadNibNamed:@"RechargeView" owner:self options:nil] lastObject];
    
    [[HTView shareHTView] setView:headView.bg_view cornerRadius:4];
    [[HTView shareHTView] setView:headView.submit cornerRadius:4];

    
    return headView;
}

@end

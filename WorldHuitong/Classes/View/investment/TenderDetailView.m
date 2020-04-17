//
//  TenderDetailView.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/8.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "TenderDetailView.h"

@implementation TenderDetailView

-(void)setViewAttribute
{
    //headView属性的设置
    self.progressScale.layer.cornerRadius = 3;
    self.bg_allButton.layer.cornerRadius = 6;
    self.progressView.layer.cornerRadius = 3;
    //
    [[HTView shareHTView] setView:self.lable1 cornerRadius:3];
    [[HTView shareHTView] setView:self.lable2 cornerRadius:3];
    [[HTView shareHTView] setView:self.lable3 cornerRadius:3];
    [[HTView shareHTView] setView:self.lable4 cornerRadius:3];

}


+(instancetype)tenderDelViewWithModle:(Biao*)modle
{
    TenderDetailView *headView = [[[NSBundle mainBundle] loadNibNamed:@"TenderDetailView" owner:self options:nil] lastObject];
    headView.bg_buttonHead.backgroundColor = HT_BG_COLOR;
    headView.bg_regBtnBotton.backgroundColor = HT_BG_COLOR;
   
    //年化
    NSString *str = [[NSString stringWithFormat:@"%@",modle.borrow_apr] stringByAppendingString:@"%"];
    headView.scale.attributedText = [[HTView shareHTView] setLableAttriText:str];
    
    //理财期限
    NSString *time = modle.borrow_period_name;
    if (time) {
        headView.timeLimit.attributedText =  [[HTView shareHTView] setLableAttriText:time];
    }
    
    //总额
    if ([modle.biao_account floatValue] >= 10000) {
        headView.rental.text = [NSString stringWithFormat:@"本期项目总额:%.2f万",[modle.biao_account floatValue] / 10000];
    }else{
        headView.rental.text = [NSString stringWithFormat:@"本期项目总额:%.f元",[modle.biao_account floatValue]];
    }
    
    //进度条
    if ([modle.borrow_account_scale floatValue] >= 100) {
        [headView.progressView setProgress:0 animated:NO];
        headView.progressView.progressTintColor = [UIColor lightGrayColor];

    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            headView.progressView.progressTintColor = HT_COLOR;
            [headView.progressView setProgress:[modle.borrow_account_scale floatValue] / 100 animated:YES];
        });
    }
    
    
    //已融资
    NSString *inanced = [[NSString stringWithFormat:@"已融资: %.2f",[modle.borrow_account_scale floatValue]]stringByAppendingString:@"%"];
    headView.inancedScale.attributedText = [self setLableColorNstring:inanced loc:4 Color:[UIColor redColor]];
    
    //可售金额
    NSString *vendibility = [NSString stringWithFormat:@"可售金额: %d元",modle.borrow_account_wait];
    headView.vendibilityMoney.text = vendibility;
    headView.vendibilityMoney.attributedText = [self setLableColorNstring:vendibility loc:5 Color:[UIColor redColor]];

    //起投金额
    headView.staryMoney.text = [NSString stringWithFormat:@"100元"];
    
    //购买次数
    NSString *buyTime = [NSString stringWithFormat:@"%.f次",modle.tender_times];
    headView.buyTimes.text = buyTime;

    //起息时间
    if ([modle.borrow_type isEqualToString:@"roam"]) {
        headView.dateOfValue.text = @"投资当天";
    }else{
        headView.dateOfValue.text = @"满标当天";
    }
    
    //还款方式
    headView.modeOfRepayment.text = modle.style_name;
    
    //设置属;性
    [headView setViewAttribute];

        
    return headView;
}


+(NSMutableAttributedString*)setLableColorNstring:(NSString *)str loc:(NSInteger)loc Color:(UIColor*)color
{
    NSMutableAttributedString *atext = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",str]];
    [atext beginEditing];
    [atext addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(loc,[str length] - loc)];
    return atext;
}


@end

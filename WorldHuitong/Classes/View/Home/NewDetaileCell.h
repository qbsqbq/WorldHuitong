//
//  NewDetaileCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/22.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDetaileCell : UIView
@property (weak, nonatomic) IBOutlet UIView *head_line;
@property (weak, nonatomic) IBOutlet UIView *foot_line;
@property (weak, nonatomic) IBOutlet UILabel *hqsy_detaile;

/***年化率**/
@property (weak, nonatomic) IBOutlet UILabel *biao_apr;

/***周期**/
@property (weak, nonatomic) IBOutlet UILabel *biao_data;

/***借款金额**/
@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UILabel *lable1;

@property (weak, nonatomic) IBOutlet UILabel *lable2;

@property (weak, nonatomic) IBOutlet UILabel *lable4;

@property (weak, nonatomic) IBOutlet UILabel *lable5;


@end

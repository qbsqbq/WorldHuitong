//
//  chooseView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chooseView : UIView
@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UIDatePicker *timePickView;

/**标种**/
@property (weak, nonatomic) IBOutlet UIButton *type;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;

/**开始时间**/
@property (weak, nonatomic) IBOutlet UIButton *startTime;
@property (weak, nonatomic) IBOutlet UILabel *startLable;

/**结束时间**/
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UILabel *endLable;


/**标种的状态**/
@property (weak, nonatomic) IBOutlet UIButton *state;
@property (weak, nonatomic) IBOutlet UILabel *stateLable;

/**确定按钮**/
@property (weak, nonatomic) IBOutlet UIButton *shureBtn;

@end

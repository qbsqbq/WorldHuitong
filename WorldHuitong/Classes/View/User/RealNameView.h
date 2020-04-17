//
//  RealNameView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealNameView : UIView
@property (weak, nonatomic) IBOutlet UITextField *realName;


@property (weak, nonatomic) IBOutlet UITextField *IDNumber;

/**提交按钮**/
@property (weak, nonatomic) IBOutlet UIButton *submit;

/**注**/
@property (weak, nonatomic) IBOutlet UILabel *zhu;


+(instancetype)realNameView;
@end

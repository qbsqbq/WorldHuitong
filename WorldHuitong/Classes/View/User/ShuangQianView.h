//
//  ShuangQianView.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShuangQianView : UIView
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**双乾logo**/
@property (weak, nonatomic) IBOutlet UIImageView *icon;

/**开通状态**/
@property (weak, nonatomic) IBOutlet UILabel *dredgState;

/**开通双乾按钮呢**/
@property (weak, nonatomic) IBOutlet UIButton *dredgShuangQian;


@end

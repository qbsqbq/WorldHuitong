//
//  RealNameResultView.h
//  WorldHuitong
//
//  Created by TXHT on 16/7/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealNameResultView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**认证状态**/
@property (weak, nonatomic) IBOutlet UILabel *renzhengState;

/**实名**/
@property (weak, nonatomic) IBOutlet UILabel *realName;

/**身份证号码**/
@property (weak, nonatomic) IBOutlet UILabel *persinId;


@end

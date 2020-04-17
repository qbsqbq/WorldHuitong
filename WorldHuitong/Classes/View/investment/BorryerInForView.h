//
//  BorryerInForView.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorryerInForView : UIView

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**性别**/
@property (weak, nonatomic) IBOutlet UILabel *sex;

/**月收入**/
@property (weak, nonatomic) IBOutlet UILabel *moth_incom;

/**出生日期**/
@property (weak, nonatomic) IBOutlet UILabel *borthData;

/**是否结婚**/
@property (weak, nonatomic) IBOutlet UILabel *isMerry;

/**工作城市**/
@property (weak, nonatomic) IBOutlet UILabel *work_city;

/**学历**/
@property (weak, nonatomic) IBOutlet UILabel *xueli;

/**工作年限**/
@property (weak, nonatomic) IBOutlet UILabel *work_time;

/**公司性质**/
@property (weak, nonatomic) IBOutlet UILabel *company_nature;

/**有无购房**/
@property (weak, nonatomic) IBOutlet UILabel *isHouse;

/**公司规模**/
@property (weak, nonatomic) IBOutlet UILabel *company_scale;

/**有无购车**/
@property (weak, nonatomic) IBOutlet UILabel *isCar;

/**岗位职称**/
@property (weak, nonatomic) IBOutlet UILabel *thePost;








@end

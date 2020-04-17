//
//  ChooseAddressCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAddressCell : UITableViewCell

/**用户名**/
@property (weak, nonatomic) IBOutlet UILabel *userName;

/**电话号码**/
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;


/**地址**/
@property (weak, nonatomic) IBOutlet UILabel *userAddress;

/**邮编**/
@property (weak, nonatomic) IBOutlet UILabel *theCode;

/**是否选中**/
@property (weak, nonatomic) IBOutlet UIButton *isifSelected;


@property (weak, nonatomic) IBOutlet UIView *bg_view;



@end

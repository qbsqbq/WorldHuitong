//
//  AddAddressHead.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/30.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddressHead : UIView

/**用户名**/
@property (weak, nonatomic) IBOutlet UITextField *userName;

/**电话号码**/
@property (weak, nonatomic) IBOutlet UITextField *phone;


/**省份**/
@property (weak, nonatomic) IBOutlet UILabel *province;


/**城市**/
@property (weak, nonatomic) IBOutlet UILabel *city;

/**地区**/
@property (weak, nonatomic) IBOutlet UILabel *area;

/**收货地址**/
@property (weak, nonatomic) IBOutlet UITextField *detaileAddress;

/**邮编**/
@property (weak, nonatomic) IBOutlet UITextField *corde;

/**选择省份按钮**/
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;

/**选择城市按钮**/
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

/**选择地区按钮**/
@property (weak, nonatomic) IBOutlet UIButton *arearBtn;

/**按成按钮**/
@property (weak, nonatomic) IBOutlet UIButton *finished;




@end

//
//  RealNameController.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealNameController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSString *userName;
@end

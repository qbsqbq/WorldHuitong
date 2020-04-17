//
//  CounterController.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/13.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)NSString *vcType; //首页或者我要投资页

@end

//
//  MyIntegralController.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/31.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//我的积分

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface MyIntegralController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)NSString *pageType;


@end

//
//  ChooseAddressController.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Address.h"

typedef void(^RetunModleBlock)(Address*address);

@interface ChooseAddressController : UIViewController
@property(nonatomic,copy)RetunModleBlock block;

-(void)retunModle:(RetunModleBlock)addBlcok;

@end

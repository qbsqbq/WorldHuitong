//
//  RegShuangQianViewController.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/17.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegShuangQianViewController : UIViewController<UIWebViewDelegate,NSURLConnectionDataDelegate>
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *alterTitle; //提示语

@end

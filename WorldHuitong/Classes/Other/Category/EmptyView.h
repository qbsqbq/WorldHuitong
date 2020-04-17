//
//  EmptyView.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView

@property(nonatomic,strong)NSString *imageName;
@property(nonatomic,strong)NSString *title;
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Image:(NSString*)igName;

@end

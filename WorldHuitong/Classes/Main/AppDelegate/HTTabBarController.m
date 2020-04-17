//
//  HTTabBarController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/8.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "HTTabBarController.h"
#import "AppDelegate.h"


@interface HTTabBarController ()
@property(nonatomic,assign)AppDelegate *app;

@end

@implementation HTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

  /**把HTTabBarController设置成app的属性**/
    self.app = (AppDelegate*)[[UIApplication sharedApplication]delegate] ;
    self.app.tabBarVC = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = HT_COLOR;

 
    
}







@end

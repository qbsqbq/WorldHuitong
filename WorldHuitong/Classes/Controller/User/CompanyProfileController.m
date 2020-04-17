//
//  CompanyProfileController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/27.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "CompanyProfileController.h"

@interface CompanyProfileController ()
@property(nonatomic,strong)UILabel *jiaoyiJinge;
@property(nonatomic,strong)UILabel *touzirenLixi;

@end

@implementation CompanyProfileController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.view];
    
    [self loadSubViews];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.tabBarVC.tabBar.hidden = YES;

}


-(void)loadSubViews
{
    self.navigationItem.title = @"公司介绍";
    
    NSString*jiaoyiJinge = [[NSUserDefaults standardUserDefaults]valueForKey:@"borrow_success_account_all"];
    NSString*touzirenLixi = [[NSUserDefaults standardUserDefaults]valueForKey:@"total_tender_interest"];
    
    //image_head
    UIImage *imageHead = [UIImage imageNamed:@"comp_intro_head"];
    float scale1 = imageHead.size.height / imageHead.size.width;
    float heigth1 = scale1 * kScreenWidth;
    UIImageView *imageViewHead = [[UIImageView alloc]initWithImage:imageHead];
    imageViewHead.frame = CGRectMake(0, 0, kScreenWidth, heigth1);
    
    //累计交易金额
   _jiaoyiJinge = [[UILabel alloc]initWithFrame:CGRectMake(0, heigth1 / 2 - 21, kScreenWidth, 21)];
    _jiaoyiJinge.text = jiaoyiJinge;
    [_jiaoyiJinge setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    _jiaoyiJinge.textAlignment = NSTextAlignmentCenter;
    _jiaoyiJinge.textColor = HT_COLOR;
    [imageViewHead addSubview:_jiaoyiJinge];
    
    //累计给投资人利息
    _touzirenLixi = [[UILabel alloc]initWithFrame:CGRectMake(0, heigth1 / 2 + 35, kScreenWidth, 21)];
    _touzirenLixi.text = touzirenLixi;
    [_touzirenLixi setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    _touzirenLixi.textAlignment = NSTextAlignmentCenter;
    _touzirenLixi.textColor = RGBA_COLOR(34, 193, 252, 1);
    [imageViewHead addSubview:_touzirenLixi];
    //image_foot
    UIImage *imageFoot = [UIImage imageNamed:@"comp_intro_foot"];
    float scale2 = imageFoot.size.height / imageFoot.size.width;
    float heigth2 = scale2 * kScreenWidth;
    UIImageView *imageViewFoot = [[UIImageView alloc]initWithImage:imageFoot];
    imageViewFoot.frame = CGRectMake(0, heigth1, kScreenWidth, heigth2);
    
    //scrollview
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = HT_BG_COLOR;
    scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64);
    scrollView.contentSize = CGSizeMake(kScreenWidth, heigth1 + heigth2);
    
    
    [scrollView addSubview:imageViewHead];
    [scrollView addSubview:imageViewFoot];
    
    
    [self.view addSubview:scrollView];


}

@end

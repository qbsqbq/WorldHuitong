//
//  SecurityViewController.m
//  WorldHuitong
//
//  Created by TXHT on 16/9/7.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "SecurityViewController.h"

@interface SecurityViewController ()
@property(nonatomic,strong) UIButton *backBtn;
@end

@implementation SecurityViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadSubViews];
    

    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


-(void)loadSubViews
{
    self.view.backgroundColor = HT_BG_COLOR;

    //scrollview
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = HT_BG_COLOR;
    scrollView.frame = CGRectMake(0,0, kScreenWidth, kScreenHeigth);
    scrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeigth * 6);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
   
    //image
    for (int i= 0; i < 6; i ++) {
        
        UIImage *imag = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",@"security",i]];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, i * kScreenHeigth, kScreenWidth, kScreenHeigth);
        imageView.image = imag;
        [scrollView addSubview:imageView];
    }
    
    [self.view addSubview:scrollView];

    //返回按钮
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 30)];
    [_backBtn setImage:[UIImage imageNamed:@"na_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}


-(void)backAction
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end

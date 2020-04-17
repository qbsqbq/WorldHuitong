//
//  AboutUsController.m
//  WorldHuitong
//
//  Created by TXHT on 16/9/7.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//了解我们
#define picNmuber 3

#import "AboutUsController.h"

@interface AboutUsController ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)AppDelegate *app;

@end

@implementation AboutUsController

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
    scrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeigth * picNmuber);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    //image
    for (int i= 0; i < picNmuber; i ++) {
        
        UIImage *imag = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",@"aboutUs",i]];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, i * kScreenHeigth, kScreenWidth, kScreenHeigth);
        imageView.image = imag;
        [scrollView addSubview:imageView];
        if (i == 1) {
            
            //累计交易量
            UILabel *title1= [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeigth*3/ 4 -40 , kScreenWidth / 2 - 22, 36)];
            title1.font = [UIFont systemFontOfSize:19];
            title1.text = @"累计成交量:";
            title1.textAlignment = NSTextAlignmentRight;
            title1.textColor = RGBA_COLOR(82, 178, 209, 1);
            [imageView addSubview:title1];
            
            //数字
            UILabel *leiJiNumber= [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 22, kScreenHeigth*3/ 4 -40 , kScreenWidth / 2 + 22, 36)];
            leiJiNumber.font = [UIFont systemFontOfSize:24];
            leiJiNumber.textColor = RGBA_COLOR(248, 115, 44, 1);
            NSString *number = [[NSUserDefaults standardUserDefaults]valueForKey:@"borrow_success_account_all"];
            
            NSString *acount = [number substringToIndex:[number length ]- 1];
            acount = [NSString stringWithFormat:@"%.2f万",[acount floatValue] / 10000];
            leiJiNumber.attributedText = [HTView setLableColorText:acount loc:1 Color:RGBA_COLOR(82, 178, 209, 1) FontOfSize:15];
            [imageView addSubview:leiJiNumber];
            
            //赚取的利息
            
            UILabel *title2= [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeigth*3/ 4 , kScreenWidth / 2 - 22, 36)];
            title2.font = [UIFont systemFontOfSize:19];
            title2.text = @"为投资人赚取:";
            title2.textAlignment = NSTextAlignmentRight;
            title2.textColor = RGBA_COLOR(82, 178, 209, 1);
            [imageView addSubview:title2];
            //数字
            UILabel *lixi= [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 22, kScreenHeigth*3/ 4 , kScreenWidth / 2 + 22, 36)];
            lixi.font = [UIFont systemFontOfSize:24];
            lixi.textColor = RGBA_COLOR(248, 115, 44, 1);
            NSString *lixiNumber = [[NSUserDefaults standardUserDefaults]valueForKey:@"total_tender_interest"];
            lixi.attributedText = [HTView setLableColorText:lixiNumber loc:1 Color:RGBA_COLOR(82, 178, 209, 1) FontOfSize:15];
            [imageView addSubview:lixi];
            
            //运行时间
            UILabel *title3= [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeigth*3/ 4 + 40, kScreenWidth / 2 - 22, 36)];
            title3.font = [UIFont systemFontOfSize:19];
            title3.text = @"安全运行:";
            title3.textAlignment = NSTextAlignmentRight;
            title3.textColor = RGBA_COLOR(82, 178, 209, 1);
            [imageView addSubview:title3];
            //数字
            UILabel *runTime= [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 22, kScreenHeigth*3/ 4 +40 , kScreenWidth / 2 + 22, 36)];
            runTime.font = [UIFont systemFontOfSize:24];
            runTime.textColor = RGBA_COLOR(248, 115, 44, 1);
            NSString *runtime = [[[NSUserDefaults standardUserDefaults]valueForKey:@"total_user_num"] stringByAppendingString:@"天"];
            runTime.attributedText = [HTView setLableColorText:runtime loc:1 Color:RGBA_COLOR(82, 178, 209, 1) FontOfSize:15];
            [imageView addSubview:runTime];
            
        }
        if (i == picNmuber - 1) {
            //立即体验
            imageView.userInteractionEnabled = YES;
            UIButton *lijitiyan = [[UIButton alloc]init];
            lijitiyan.frame = CGRectMake(0, kScreenHeigth - 46, kScreenWidth, 46);
            lijitiyan.backgroundColor = [UIColor clearColor];
            [lijitiyan addTarget:self action:@selector(lijitiyanAction) forControlEvents:UIControlEventTouchUpInside];
            [lijitiyan setTitle:@"" forState:UIControlStateNormal];
            [imageView addSubview:lijitiyan];
        }
        
    }
    
    [self.view addSubview:scrollView];
    
    //返回按钮
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 30)];
    [_backBtn setImage:[UIImage imageNamed:@"na_back_y"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}

//立即体验
-(void)lijitiyanAction
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.app = (AppDelegate*)[[UIApplication sharedApplication]delegate] ;
    self.app.tabBarVC.selectedIndex = 1;
}

-(void)backAction
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end

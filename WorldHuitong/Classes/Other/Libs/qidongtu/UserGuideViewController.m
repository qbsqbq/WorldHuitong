//
//  UserGuideViewController.m
//  Resume
//
//  Created by 屈跃庭 on 16/1/27.
//  Copyright © 2016年 屈跃庭. All rights reserved.
//

#define   MainScreenW  [UIScreen mainScreen].bounds.size.width
#define   MainScreenH  [UIScreen mainScreen].bounds.size.height

#import "UserGuideViewController.h"
#import "HomeController.h"
@interface UserGuideViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation UserGuideViewController
- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
   

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //不隐藏tabbar
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.tabBarVC.tabBar.hidden = NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addImageViewOnScrollView];
//    [self layOUtPageControl];
}
#pragma mark --布局子视图--

-(void)addImageViewOnScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4,0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
        _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView ];
    for(int i = 0; i < 4; i++)
    {
        CGRect frame=[[UIScreen mainScreen] bounds];
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"banner0%d",(i + 1)]];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.frame = CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height);
        [_scrollView addSubview:imageView];
        //添加手势视图
        if(i==3)
        {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame=CGRectMake(MainScreenW / 2 - 100,MainScreenH - 100, 200, 45);
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 4;
            btn.backgroundColor = HT_COLOR;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.tintColor = [UIColor whiteColor];
            [btn setTitle:@"点击进入" forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont fontWithName:@"AmericanTypewriter" size:20];
            btn.tintColor=[UIColor orangeColor];
            [btn addTarget:self action:@selector(tapHandle:) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled=YES;
            [imageView addSubview:btn];
        }
    }
}

-(void)layOUtPageControl
{
    //******************************************创建PageControl
    //self.view.backgroundColor = [UIColor purpleColor];
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreenW / 2 - 110, self.view.frame.size.height-100, 220, 60)];
    //页数
    self.pageControl.numberOfPages = 4;
    //设置默认 页
    self.pageControl.currentPage = 0;
    //设置当前点得颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor  = [UIColor lightGrayColor];
    //***************添加方法
    [self.pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
    //添加
    [self.view addSubview:_pageControl];
    
}

//pageControl
-(void)pageControl:(UIPageControl*)pageControl
{
    NSInteger page_cur = pageControl.currentPage;
    _scrollView.contentOffset = CGPointMake(320 * page_cur, 0);
}

//重写介乎拖拽函数
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point =  scrollView.contentOffset;
    NSInteger cur_page = point.x/320;
    _pageControl.currentPage = cur_page;
    
}

//点击进入
-(void)tapHandle:(UIButton*)btn
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HTTabBarController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HTTabBarController"];
   
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.window.rootViewController = homeVC ;
    
}



@end

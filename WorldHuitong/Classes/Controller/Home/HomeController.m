 //
//  HomeController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/1.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#define kTableName @"recommendBiaoInfo"
#define kID @"ID"


#define kHeadViewId @"HomeHeadView"
#define kCellHeigth 140
#import "HomeController.h"
#import "HomeHeadView.h"
#import "HomeJiYiAmountCell.h"
#import "HomeRecommendCell.h"
#import "NewStandardCell.h"
#import "AboutUsController.h"
#import "SecurityViewController.h"
#import "HomeMarkCell.h"
#include "NewBiaoDetaileController.h"
#import "NewWelfareController.h"
#import "KNCirclePercentView.h"    //圆圈比例饼状图
#import "LogController.h"          //登录
#include "MyIntegralController.h"  //积分商城
#import "ZiJingDaoZahngController.h"
#import "Biao.h"
#import "TenderDetailController.h"
@interface HomeController ()


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,retain)AppDelegate *app;
@property(nonatomic,retain)NSArray *imagesURLs;
@property(nonatomic,retain)NSArray *markTitles;
@property(nonatomic,retain)NSArray *markImages;
@property(nonatomic,strong)NSMutableArray *full_pic_urls;  // 轮播图的urls
@property(nonatomic,strong)NSMutableArray *urls;           // 点击后的跳转地址

@property(nonatomic,retain)KNCirclePercentView *circleView;
@property(nonatomic,retain)Biao *recommBiao;
@property(nonatomic,retain)NewBiao *xinBiao;
@property(nonatomic,retain)NSArray *recommBiaos;



@property(nonatomic,strong)NSString *jiaoyiJinge;
@property(nonatomic,strong)NSString *touzirenLixi;
@property(nonatomic,strong)NSIndexPath *index;

@end

@implementation HomeController

-(NSMutableArray *)full_pic_urls
{
    if (nil ==_full_pic_urls) {
        
        _full_pic_urls = [[NSMutableArray alloc]init];
        //轮播图数据
        [self loadTheCarouselData];
    }
    return _full_pic_urls;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.view];
    
    [self setNavigationBar];
    
    //平台数据
    [self loadThejiaoyiAmount];
    
    //新标数据
    [self loadNweBiaoData];
    
    //推荐标数据
    [self loadTheRecommendData];

    //添加刷新
    [self autoRefreshing];
    
}

#pragma ----UICollectionViewDataSource----

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return _markTitles.count;
    }
    
    if (section == 3) {
        return _recommBiaos.count;
    }
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        _jiaoyiJinge = [[NSUserDefaults standardUserDefaults]valueForKey:@"borrow_success_account_all"];
        _touzirenLixi = [[NSUserDefaults standardUserDefaults]valueForKey:@"total_tender_interest"];
        
        HomeJiYiAmountCell *cell =  [HomeJiYiAmountCell homeJiYiAmountCellWith:collectionView IndexPath:indexPath Amount:_jiaoyiJinge Lixi:_touzirenLixi];
        _index = indexPath;
        
        return cell;
    }
    if (indexPath.section == 1) {
        
         return [HomeMarkCell MarkCellWith:collectionView IndexPath:indexPath titleArr:_markTitles ImageArr:_markImages];
    }
    if (indexPath.section == 2) {
        
        NewStandardCell *cell = [NewStandardCell newStandardCellWith:collectionView IndexPath:indexPath Modle:_xinBiao];
        UIButton *liji = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 20 - 90, 120 - 8 -30, 90, 30)];
        liji.backgroundColor = HT_COLOR;
        [cell.bg_view addSubview:liji];
        [[HTView shareHTView]setView:liji cornerRadius:3];
        [liji setTitle:@"立即抢购" forState:UIControlStateNormal];
        liji.titleLabel.font = [UIFont systemFontOfSize:16];
        [liji addTarget:self action:@selector(lijiBuyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return [HomeRecommendCell RecommendCellWith:collectionView IndexPath:indexPath Modle:_recommBiaos[indexPath.row]];

}

#pragma ----UICollectionViewDelegateFlowLayout----

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth , 50);
    }
    if (indexPath.section == 1) {
        float W = (kScreenWidth) / 2;
        float H = 70;

        return CGSizeMake(W , H);
    }
    if (indexPath.section == 2) {
        return CGSizeMake(kScreenWidth, 170);
    }
 
    return CGSizeMake(kScreenWidth , 129);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{return 0;}

#pragma ----设置cell的高亮----

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
        UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 2) {
        
    }else {
    
        //设置(Highlight)高亮下的颜色
        [cell setBackgroundColor:HT_BG_COLOR];
    }
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 || indexPath.section == 2 ) {
        
    }else{
        UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
        //设置(Nomal)正常状态下的颜色
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0 || section == 1) {
        
          return UIEdgeInsetsMake(10, 0, 0, 0);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//head的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(self.view.bounds.size.width, kScreenWidth / 2.6);
    }
    return CGSizeMake(0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            if ([Tools isConnectionAvailable]) {
                self.hidesBottomBarWhenPushed = YES;
                [self performSegueWithIdentifier:@"NewWelfareController" sender:nil];       //新手福利
                self.hidesBottomBarWhenPushed = NO;
            }else{
                [HTView isWiffOnView:self.view];
            }

        }
        if (indexPath.row == 1) {
       
                self.navigationController.navigationBarHidden = YES;
                self.hidesBottomBarWhenPushed = YES;
                AboutUsController *aboutus = [[AboutUsController alloc]init];
                [self.navigationController pushViewController:aboutus animated:YES];    //了解我们
                self.hidesBottomBarWhenPushed = NO;

        }
        if (indexPath.row == 2) {
                
                self.navigationController.navigationBarHidden = YES;
                self.hidesBottomBarWhenPushed = YES;
                SecurityViewController *securvc = [[SecurityViewController alloc]init];
                [self.navigationController pushViewController:securvc animated:YES];     //安全保障
                self.hidesBottomBarWhenPushed = NO;
            
        }
        if (indexPath.row == 3) {
            
            if (kUSER_ID) {
                self.hidesBottomBarWhenPushed = YES;
                MyIntegralController *integralVC = [[MyIntegralController alloc]init];   //积分商城
                integralVC.pageType = @"home";
                [self.navigationController pushViewController:integralVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                
            }else{
                [self presentViewController:[[LogController alloc]init] animated:YES completion:nil];
            }


        }
    }
    if (indexPath.section == 3) {
        if ([Tools isConnectionAvailable]) {                                           //推荐标的详情
            
            self.hidesBottomBarWhenPushed = YES;
            TenderDetailController *detaie = (TenderDetailController*)[self.storyboard instantiateViewControllerWithIdentifier:@"TenderDetailController"];
            detaie.vcType = @"home";
            detaie.biao = _recommBiaos[indexPath.row];
            [self.navigationController pushViewController:detaie animated:YES];
            self.hidesBottomBarWhenPushed = NO;

        }else{
            [HTView isWiffOnView:self.view];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewBiaoDetaileController"]) {
      
        NewBiaoDetaileController *newVC = segue.destinationViewController;
        newVC.xinBiao = _xinBiao;
    }if ([segue.identifier isEqualToString:@"NewWelfareController"]) {
        NewWelfareController *newwelfare = segue.destinationViewController;
        newwelfare.xinBiao = _xinBiao;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HomeHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeadViewId forIndexPath:indexPath];
//        NSLog(@"+++++++++++++%@",self.full_pic_urls);

            //添加轮播图
            [self addSdCycleScrollView:headerView];
    
        
        reusableview = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        return nil;
    }
    return reusableview;
}


#pragma ----SDCycleScrollViewDelegate----

-(void)addSdCycleScrollView:(UIView *)view
{
    SDCycleScrollView *cycView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2.6) delegate:self placeholderImage:nil];
    cycView.placeholderImage = [UIImage imageNamed:@"image_hoeld"];
    cycView.imageURLStringsGroup = self.full_pic_urls;
    cycView.currentPageDotColor = HT_COLOR;
    cycView.hidesForSinglePage = YES;
    cycView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycView.pageDotColor = [UIColor whiteColor];
    [view addSubview:cycView];
    
}


//点击用户按钮
-(void)userAction
{
    if (kUSER_ID) {
        
        self.app = (AppDelegate*)[[UIApplication sharedApplication]delegate] ;
        self.app.tabBarVC.selectedIndex = 2;
    }else{
        LogController *log = [[LogController alloc]init];
        [self presentViewController:log animated:YES completion:nil];
    }
    
}

//立即购买新手标
-(void)lijiBuyBtnAction
{
    if ([Tools isConnectionAvailable]) {
        self.hidesBottomBarWhenPushed = YES;
        [self performSegueWithIdentifier:@"NewBiaoDetaileController" sender:nil];
        self.hidesBottomBarWhenPushed = NO;
        
    }else{
        [HTView isWiffOnView:self.view];
    }

}

//自定刷新
-(void)autoRefreshing
{
    //1.自动刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        [HTView isWiffOnView:self.view];
        [self.full_pic_urls removeAllObjects];
        [self loadTheCarouselData];   //请求轮播图数据
        [self loadTheRecommendData];  //请求推荐标数据
    }];
    
}


//平台数据
-(void)loadThejiaoyiAmount
{
    NSDictionary *dic = @{
                          @"module":@"borrow",
                          @"q":@"get_web_count",
                          @"method":@"get",
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
        //请求数据
        NSString*jiaoyiJinge = [NSString stringWithFormat:@"%@元",response[@"borrow_success_account_all"]];
        NSString*touzirenLixi = [NSString stringWithFormat:@"%@元",response[@"total_tender_interest"]];
        NSString *totalUserNumer = response[@"total_user_num"];
        
        //把平台数据存本地
        [[NSUserDefaults standardUserDefaults]setValue:jiaoyiJinge forKey:@"borrow_success_account_all"];
        [[NSUserDefaults standardUserDefaults]setValue:touzirenLixi forKey:@"total_tender_interest"];
        [[NSUserDefaults standardUserDefaults]setValue:totalUserNumer forKey:@"total_user_num"];
        
        //刷新
       [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];

    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

//新手标数据
-(void)loadNweBiaoData
{
    NSDictionary*diccc = @{
                           @"method":@"get",
                           @"module":@"borrow",
                           @"q":@"get_new_borrow",
                           };
    
    NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
    NSString *strHT = [[Tools shareTools]htstr:str];
    NSString *md5Par = [[Tools shareTools] md5:strHT];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:YES params:par success:^(id response) {

        _xinBiao = [NewBiao mj_objectWithKeyValues:response];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
     
    } fail:^(NSError *error) {
        
    }];
    
}

//推荐标数据
-(void)loadTheRecommendData
{
    NSDictionary*diccc = @{
                           @"method":@"get",
                           @"module":@"borrow",
                           @"q":@"get_recommend_list",
                           };
    
    NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
    NSString *strHT = [[Tools shareTools]htstr:str];
    NSString *md5Par = [[Tools shareTools] md5:strHT];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {

       _recommBiaos = [Biao mj_objectArrayWithKeyValuesArray:response[@"list"]];
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
        [self.collectionView.mj_header endRefreshing];

    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

//轮播图数据
-(void)loadTheCarouselData
{
    NSDictionary*diccc = @{@"status":@"1",
                           @"method":@"get",
                           @"module":@"scrollpic",
                           @"q":@"mobile_get_list",
                           @"limit":@"all"
                           };
    
    NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
    NSString *strHT = [[Tools shareTools]htstr:str];
    NSString *md5Par = [[Tools shareTools] md5:strHT];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:YES params:par success:^(id response) {
       
    
        NSArray *list = response[@"list"];
        for (NSDictionary *dic in list) {
            NSString *full_pic_url = dic[@"full_pic_url"];
            NSString *url = dic[@"url"];
            [_full_pic_urls addObject:full_pic_url];
            [_urls addObject:url];
        }
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
    
}

-(void)setNavigationBar
{
    self.urls = [[NSMutableArray alloc]init];
    
    //设置statusbar的颜色
    [[HTView shareHTView]setStatusBarBg:self.navigationController];
    self.view.backgroundColor = HT_BG_COLOR;
    //添加rightBarButtonItem
    self.navigationItem.titleView = [[HTView shareHTView]getImageViewWithImage:@"logo_ company"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_selected"] style:(UIBarButtonItemStylePlain) target:self action:@selector(userAction)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = HT_COLOR;
    self.navigationItem.title = @"";
    
    _markTitles = @[@"新手福利",@"了解我们",@"安全保障",@"积分商城"];
    _markImages = @[@"newer_fuli",@"about_us",@"safe_bangzhang",@"lookfor_"];
    

    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    
    if (self.full_pic_urls) {
        [_collectionView registerClass:[HomeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeadViewId];
        
    }


   }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    //获取通知中心单例对象---（首页很听话，接到指纹界面的消息后立马进入登陆界面再次登陆）
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者
    [center addObserver:self selector:@selector(toLogVC:) name:@"toLogVC" object:nil];
}


//接受通知，再次进入登陆界面，用户登陆
-(void)toLogVC:(NSNotification*)notification
{
    LogController *logVC = [[LogController alloc]init];
    [self presentViewController:logVC animated:NO completion:nil];
}




@end

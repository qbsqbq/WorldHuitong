//
//  FinanceViewController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/13.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//实时财务

#import "FinanceViewController.h"
#import "FinanceHeadCell.h"
#import "FinanceCell.h"
#import "RechargeController.h" //充值
#import "WithdrawController.h" // 提现
@interface FinanceViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSString *recoverProfit;  //净收益
@property(nonatomic,strong)NSArray *moneys;

//数据属性
@property(nonatomic,strong)NSString *balance;               //可用金额
@property(nonatomic,strong)NSString *frost;                 //冻结金额
@property(nonatomic,strong)NSString *total;                 //用户总额
@property(nonatomic,strong)NSString *tender_wait_capital;   //待收本金
@property(nonatomic,strong)NSString *recover_yes_interest;  //已收利息
@property(nonatomic,strong)NSString *tender_wait_interest;  //待收利息


@end

@implementation FinanceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //获取财务数据
    [self loadFinanceData];
    
    _titles = @[@"可用金额（¥）",@"冻结金额（¥）",@"用户总额（¥）",@"待收本金（¥）",@"已收利息（¥）",@"待收利息（¥）"];
    
    //1.自动刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //检测网络
        [HTView isWiffOnView:self.view];
        [self loadFinanceData];
    }];
    
    [self.collectionView.mj_header beginRefreshing];   //马上进入刷新状态
    
}

#pragma ----UICollectionViewDataSource----
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {return 6;}
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"FinanceCell";
    static NSString *headId = @"FinanceHeadCell";
    
    if (indexPath.section == 0) {
        FinanceHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:headId forIndexPath:indexPath];
        if (_recoverProfit) {
            cell.inCome.text = _recoverProfit;
        }

        return cell;
    }
    FinanceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.title.text = _titles[indexPath.row];
    if (_recoverProfit) {
        cell.money.text = [NSString stringWithFormat:@"%@",self.moneys[indexPath.row]];
    }
    
    return cell;
}

#pragma ----UICollectionViewDelegateFlowLayout----

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {return CGSizeMake(kScreenWidth, 126);}
    
    float W = kScreenWidth / 2;
    float H = W * 3 / 5;
    return CGSizeMake(W,H);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    //隐藏tabbar
     AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.tabBarVC.tabBar.hidden = YES;
}


-(void)loadFinanceData
{
    NSDictionary*diccc = @{
                           @"method":@"get",
                           @"module":@"account",
                           @"q":@"mobile_get_account_result",
                           @"user_id":[Tools HtUserId]
                           };
    
    NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
    NSString *strHT = [[Tools shareTools]htstr:str];
    NSString *md5Par = [[Tools shareTools] md5:strHT];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//      NSLog(@"%@",response);

        _balance = response[@"_balance"];
        _frost = response[@"_frost"];
        _total = response[@"_total"];
        _tender_wait_capital = response[@"tender_wait_capital"];
        _recover_yes_interest = response[@"recover_yes_interest"];
        _tender_wait_interest = response[@"tender_wait_interest"];
        _recoverProfit = response[@"recover_yes_profit"];
        self.moneys = @[_balance,_frost,_total,_tender_wait_capital,_recover_yes_interest,_tender_wait_interest];

        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];

    } fail:^(NSError *error) {

        [self.collectionView.mj_header endRefreshing];
    }];
    




}

//充值
- (IBAction)chongZhiAction:(UIButton *)sender
{
    RechargeController *recharge = [self.storyboard instantiateViewControllerWithIdentifier:@"RechargeController"];
    [self.navigationController pushViewController:recharge animated:YES];
}

//提现
- (IBAction)tiXianAcition:(id)sender
{
    WithdrawController *withdraw = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawController"];
    [self.navigationController pushViewController:withdraw animated:YES];

}





@end

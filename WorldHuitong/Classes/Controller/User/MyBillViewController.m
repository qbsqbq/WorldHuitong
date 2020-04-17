//
//  MyBillViewController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/27.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "MyBillViewController.h"
#import "MyBillCell.h"
#import "MyBill.h"
#import "EmptyView.h"
@interface MyBillViewController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *myBills;
@property(nonatomic)NSString *pages;
/**空的图片**/
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation MyBillViewController

-(EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64) Title:@"我的账单空空如也" Image:@"touzi"];
    }
    return _emptyView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.view];

    [self creatTableView];
   
    [self loadBillData];

    [self refreshData];
}

-(void)refreshData
{
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [HTView isWiffOnView:self.view];
        [self loadBillData];
    }];
    
    //加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pages = [NSString stringWithFormat:@"%d",[_pages intValue] + 20];
        [HTView isWiffOnView:self.view];
        [self loadBillData];
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myBills.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBillCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MyBillCell" owner:self options:nil] lastObject];
    
    MyBill *myBill = _myBills[indexPath.row];
    
    //资金流动的方向
    cell.actionName.text = myBill.action_name;
    
    //资金变动的金额
    if ([myBill.action_name isEqualToString:@"支出"]) {
        cell.account.text = [NSString stringWithFormat:@"-%@",myBill.money];
    }else if([myBill.action_name isEqualToString:@"收入"]){
        cell.account.text = [NSString stringWithFormat:@"+%@",myBill.money];
    }else{
        cell.account.text = myBill.money;
    }
    
    //图片
    if ([myBill.action_name isEqualToString:@"收入"]) {
        cell.typeImageView.image =  [UIImage imageNamed:@"shouru"];
    }else if([myBill.action_name isEqualToString:@"支出"]){
        cell.typeImageView.image =  [UIImage imageNamed:@"zhichu"];
    }else if([myBill.action_name isEqualToString:@"待收"]) {
        cell.typeImageView.image =  [UIImage imageNamed:@"daishou"];
    }else if([myBill.action_name isEqualToString:@"冻结"]){
        cell.typeImageView.image =  [UIImage imageNamed:@"dongjie"];
    }
   
    //备注
    cell.renark_account.text = myBill.remark;
    
    //时间
    cell.time.text = [Tools dateFormatterShort:[myBill.addtime intValue]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)loadBillData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    //筛选数据
    NSDictionary *dic = @{
                          @"module":@"account",
                          @"q":@"get_mobile_log_list",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId],
                          @"epage":_pages,
                          @"page":@"1"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//        NSLog(@"%@",response);
        
        //将字典数组转为模型数组
        _myBills = [MyBill mj_objectArrayWithKeyValuesArray:response[@"list"]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [[Tools shareTools]hidenHud];
        
        
        //添加空白占位图
        if (_myBills.count == 0) {
            [_tableView addSubview:self.emptyView];
            [self.tableView reloadData];
            
        }else{
            [self.emptyView removeFromSuperview];
            [self.tableView reloadData];
        }
        
        //结束刷新
        if ([response[@"total"] intValue] == _myBills.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }

    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [[Tools shareTools]hidenHud];

    }];

}

-(void)creatTableView
{
    _pages = @"20";
    self.navigationItem.title = @"我的账单";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64)];
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    //隐藏tabbar
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.tabBarVC.tabBar.hidden = YES;
}

@end

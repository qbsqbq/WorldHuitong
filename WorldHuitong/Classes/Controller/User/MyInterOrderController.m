//
//  MyInterOrderController.m
//  WorldHuitong
//
//  Created by TXHT on 16/9/1.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "MyInterOrderController.h"
#import "MyInteOrderCell.h"
#import "MyOrder.h"
#import "UIImageView+WebCache.h"
#import "EmptyView.h"
@interface MyInterOrderController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *myOrders;
@property(nonatomic)NSString *pages;
@property(nonatomic,strong)EmptyView *emptyView;


@end

@implementation MyInterOrderController


-(EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64) Title:@"暂无订单" Image:@"touzi"];
    }
    return _emptyView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.view];

    [self creatTableView];
    
    [self loaddata];
    
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loaddata];
    }];
    
    //加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pages = [NSString stringWithFormat:@"%d",[_pages intValue] + 10];
        [self loaddata];
    }];
}


#pragma ----UITableViewDataSource----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myOrders.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInteOrderCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MyInteOrderCell" owner:self options:nil] lastObject];
    MyOrder *myOrder = _myOrders[indexPath.row];
    cell.time.text = [Tools dateFormatterShort:[myOrder.addtime intValue]];
    if ([myOrder.status isEqualToString:@"1"]) {
        cell.payStay.text = @"已支付";
        cell.payStay.textColor = [UIColor lightGrayColor];
    }else{
        cell.payStay.text = @"未支付";
    }
    
    cell.shopName.text = myOrder.goods_name;
    cell.jifenCount.text = [NSString stringWithFormat:@"合计:%@积分",myOrder.integral];
    cell.number.text = [NSString stringWithFormat:@"x%@",myOrder.num];
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kBaseImageUrl,myOrder.thumb];
    [cell.shopIcon sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    
    cell.bg_view.backgroundColor = HT_BG_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

/**
 *  请求我的订单数据
 */
-(void)loaddata
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"goods",
                          @"q":@"get_order_list",
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
        
//        NSLog(@"******%@",response);
        
        //将字典数组转为模型数组
        _myOrders = [MyOrder mj_objectArrayWithKeyValuesArray:response[@"list"]];
        [self.tableView reloadData];
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_header endRefreshing];
        
        //没有数据时候结束加载
        if (_myOrders.count == [response[@"total"] intValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        //添加空白占位图
        if (_myOrders.count == 0) {
            [self.tableView addSubview:self.emptyView];
        }else{
            [self.emptyView removeFromSuperview];
        }

    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [[Tools shareTools]hidenHud];
    }];
}


-(void)creatTableView
{
    self.view.backgroundColor = HT_BG_COLOR;
    self.title = @"我的订单";
    _pages = @"10";
    self.view.backgroundColor = HT_BG_COLOR;
    if ([_pageType isEqualToString:@"home"]) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth)];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64)];
    }
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}


@end

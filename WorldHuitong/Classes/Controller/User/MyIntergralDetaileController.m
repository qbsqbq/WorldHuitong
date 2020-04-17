//
//  MyIntergralDetaileController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "MyIntergralDetaileController.h"
#import "MyIntegral.h"
#import "MyIntegralCell.h"
#import "EmptyView.h"
@interface MyIntergralDetaileController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *pages;
@property(nonatomic,strong)NSArray *myIntegrals;
@property(nonatomic,strong)NSString *outOrInt;        //消费还是获取
@property(nonatomic,strong)UISegmentedControl *seg;

/**空的图片**/
@property(nonatomic,strong)EmptyView *emptyView;


@end

@implementation MyIntergralDetaileController

-(UISegmentedControl *)seg
{
    if (!_seg) {
       _seg = [[UISegmentedControl alloc]initWithItems:@[@"获取",@"消费"]];
        _seg.frame = CGRectMake(10, 10, kScreenWidth - 20, 34);
        _seg.selectedSegmentIndex = 0;
        [_seg addTarget:self action:@selector(selectSeg:) forControlEvents:UIControlEventValueChanged];
        _seg.tintColor = RGBA_COLOR(31, 144, 230, 1);
        _seg.momentary = NO;
    }
    return _seg;
}

-(EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 54, kScreenWidth, kScreenHeigth - 64 - 54) Title:@"积分记录空空如也哦" Image:@"touzi"];
    }
    return _emptyView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self cleartTableView];
    
    [self loadIntergralNotesData];

    [self uploadMore];
}

-(void)uploadMore
{
    //加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [HTView isWiffOnView:self.view];
        
        if ([_outOrInt isEqualToString:@"into"]) {
            
            _pages = [NSString stringWithFormat:@"%d",[_pages intValue]+ 10];
            [self loadIntergralNotesData];
        }else if ([_outOrInt isEqualToString:@"out"]){
            _pages = [NSString stringWithFormat:@"%d",[_pages intValue]+ 10];
            [self loadConsumptionNotesData];
        }
    }];
}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myIntegrals.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyIntegralCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MyIntegralCell" owner:self options:nil]lastObject];
    MyIntegral *integral = _myIntegrals[indexPath.row];
    if ([_outOrInt isEqualToString:@"into"]) {
        //获取积分
        cell.integtal_number.text = [NSString stringWithFormat:@"+%@",integral.value];
        cell.integral_type.text = integral.remark;
        cell.detail_sorse.text = [Tools dateFormatterShort:[integral.addtime intValue]];
        
    }else if ([_outOrInt isEqualToString:@"out"]){
        //消费积分
        cell.integtal_number.text = [NSString stringWithFormat:@"-%@",integral.integral];
        
        NSString *jifen =[NSString stringWithFormat:@"%@  x%@",integral.goods_name,integral.num];
        cell.integral_type.attributedText =[HTView setLableColorText:jifen loc:3 Color:[UIColor lightGrayColor] FontOfSize:17];
        cell.detail_sorse.text = [Tools dateFormatterShort:[integral.addtime intValue]];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.seg];
    return view;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

-(void)selectSeg:(UISegmentedControl*)seg
{
    if (seg.selectedSegmentIndex == 0) {
        _outOrInt= @"into";
        [self loadIntergralNotesData];
    }else{
        _outOrInt= @"out";
        _pages = @"10";
        [self loadConsumptionNotesData];
    }
}


//积分记录
-(void)loadIntergralNotesData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"credit",
                          @"q":@"get_log_list",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId],
                          @"page":@"1",
                          @"nid":@"tender_success",
                          @"epage":_pages
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
        [[Tools shareTools]hidenHud];
        
//        NSLog(@"%@",response);
        _myIntegrals = [MyIntegral mj_objectArrayWithKeyValuesArray:response[@"list"]];
        
        //添加空白图片
        if (_myIntegrals.count == 0) {
            [self.tableView addSubview:self.emptyView];
        }else{
            [self.emptyView removeFromSuperview];
        }
        
        //结束加载更多
        if ([response[@"total"] intValue] == _myIntegrals.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];

    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_footer endRefreshing];


    }];
    
}

//积分消费记录
-(void)loadConsumptionNotesData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"goods",
                          @"q":@"get_order_list",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId],
                          @"page":@"1",
                          @"epage":_pages
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        [[Tools shareTools]hidenHud];
        
//        NSLog(@"%@",response);
        _myIntegrals = [MyIntegral mj_objectArrayWithKeyValuesArray:response[@"list"]];
        
        //添加空白图片
        if (_myIntegrals.count == 0) {
            [self.tableView addSubview:self.emptyView];
        }else{
            [self.emptyView removeFromSuperview];
        }
        
        //结束加载更多
        if ([response[@"total"] intValue] == _myIntegrals.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }

        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_footer endRefreshing];


    }];
    
}

-(void)cleartTableView
{
    _pages = @"10";
    _outOrInt = @"into";
    
    self.view.backgroundColor = HT_BG_COLOR;
    self.title = @"积分明细";
    if ([_pageType isEqualToString:@"home"]) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth)];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64)];
    }
    _tableView.backgroundColor = HT_BG_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
}

@end

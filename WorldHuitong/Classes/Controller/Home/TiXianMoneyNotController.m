//
//  TiXianMoneyNotController.m
//  WorldHuitong
//
//  Created by TXHT on 16/6/2.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "TiXianMoneyNotController.h"
#import "MoneyNote.h"
#import "MoneyNoteCell.h"
#import "EmptyView.h"

@interface TiXianMoneyNotController ()
@property(nonatomic,strong)NSArray *moneyNotes;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *pages;
/**空的图片**/
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation TiXianMoneyNotController

-(EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth -64) Title:@"您的提现记录为空" Image:@"touzi"];
    }
    return _emptyView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatTableView];
    
    [self refreshData];
    
}

-(void)refreshData
{
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //检测网络
        [HTView isWiffOnView:self.view];
        [self loadMoneyNoteData];
    }];
    
    [self.tableView.mj_header beginRefreshing];   //马上进入刷新状态

    //加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pages = [NSString stringWithFormat:@"%d",[_pages intValue] + 10];
        [self loadMoneyNoteData];
    }];


}

#pragma----UITableViewDataSource -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _moneyNotes.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MoneyNoteCell MoneyNoteCellWithIndexPath:indexPath Modle:_moneyNotes[indexPath.row] Who:@"tixian"];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

-(void)loadMoneyNoteData
{
    NSDictionary*diccc = @{
                           @"module":@"account",
                           @"q":@"get_cash_list",
                           @"method":@"get",
                           @"user_id":[Tools HtUserId],
                           @"page":@"1",
                           @"epage":_pages
                           };
    
    NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
    NSString *strHT = [[Tools shareTools]htstr:str];
    NSString *md5Par = [[Tools shareTools] md5:strHT];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//                NSLog(@"%@",response);
        
        //分装数组模型
        _moneyNotes  = [MoneyNote mj_objectArrayWithKeyValuesArray:response[@"list"]];
        
        if (_moneyNotes.count == 0) {
            [_tableView addSubview:self.emptyView];
            [self.tableView reloadData];
            
        }else{
            [self.emptyView removeFromSuperview];
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if ([response[@"total"] intValue] == _moneyNotes.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    
}


-(void)creatTableView
{
    _pages = @"20";
     self.navigationItem.title = @"提现记录";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64)];
    _tableView.dataSource = self;
    _tableView.delegate  = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = HT_BG_COLOR;
    
    
}

@end

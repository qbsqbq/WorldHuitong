//
//  JiaoYiRecordController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/20.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//
#define ID @"JiaoYiRecordCell"

#import "JiaoYiRecordController.h"
#import "JiaoYiRecordCell.h"
#import "JiaoYiHeadView.h"
#import "JiaoYiRecord.h"
#import "EmptyView.h"

@interface JiaoYiRecordController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)JiaoYiHeadView *head;
@property(nonatomic,strong)NSString *account_sum;   //投资总额
@property(nonatomic,strong)NSArray *jiaoYiRecords;
@property(nonatomic,strong)NSString *pages;
/**空的图片**/
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation JiaoYiRecordController


-(EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 71, kScreenWidth, kScreenHeigth - 71-64) Title:@"还没有人投资哦，赶快下手吧！" Image:@"touzi"];
    }
    return _emptyView;
}

-(JiaoYiHeadView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle] loadNibNamed:@"JiaoYiHeadView" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth,70);
    }
    return _head;

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self creatTableView];
    
    [self loadJiaoYiRecordData];
    
    [HTView isWiffOnView:self.view];

    
    //1.刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
     
        [HTView isWiffOnView:self.view];

        [self loadJiaoYiRecordData];

    }];
    
    //加载
    self.tableView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pages = [NSString stringWithFormat:@"%d",[_pages intValue] + 20];
        [self loadJiaoYiRecordData];
    }];
}

#pragma ----UITableViewDataSource----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _jiaoYiRecords.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JiaoYiRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    JiaoYiRecord *jiaoYir = _jiaoYiRecords[indexPath.row];
    
    
    if ([jiaoYir.username length] == 11) {
        cell.name.text = [NSString stringWithFormat:@"%@*%@",[jiaoYir.username substringToIndex:3],[jiaoYir.username substringFromIndex:8]];
    }else if ([jiaoYir.username length] <=3){
    cell.name.text = [NSString stringWithFormat:@"%@*******",[jiaoYir.username substringToIndex:1]];
    }else{
        NSString *head = [jiaoYir.username substringToIndex:3];
        cell.name.text = [NSString stringWithFormat:@"%@****",head];
    }
    cell.amount.text = [NSString stringWithFormat:@"￥%@",jiaoYir.account];
    cell.date.text =[Tools dateFormatterShort: [jiaoYir.addtime intValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    self.head.numberP.text = [NSString stringWithFormat:@"%ld",(unsigned long)_jiaoYiRecords.count];
    if ([_account_sum floatValue] >= 10000) {
        self.head.amount.text = [NSString stringWithFormat:@"￥%.4f万",[_account_sum floatValue] / 10000];
    }else{
        self.head.amount.text = [NSString stringWithFormat:@"￥%.2f",[_account_sum floatValue]];
    }


    return self.head;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section >0) {
        return 0;
    }
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)loadJiaoYiRecordData
{

    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"borrow",
                          @"q":@"get_tender_list",
                          @"method":@"get",
                          @"borrow_nid":_borrow_nid,
                          @"limit":@"all",
                          @"order":@"tender_addtime",
                          @"page":@"1",
                          @"epage":_pages
                          };
    
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//       NSLog(@"%@********************",response);

        //投资总额
        if ([response[@"account_sum"] isEqual:[NSNull null]]) {
        }else {
            _account_sum = response[@"account_sum"];
        }

        //mj字典转模型
        _jiaoYiRecords = [JiaoYiRecord mj_objectArrayWithKeyValuesArray:response[@"list"]];
        
        //添加空白占位页
        if (_jiaoYiRecords.count == 0) {
            [_tableView addSubview:self.emptyView];
            [self.tableView reloadData];
        }else{
            [self.emptyView removeFromSuperview];
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_header endRefreshing];
        
        
        //结束加载
        if ([response[@"total"] intValue] == _jiaoYiRecords.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } fail:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_footer endRefreshing];

        
    }];



}

-(void)creatTableView
{
    _pages = @"20";
    self.navigationItem.title = @"交易记录";
    self.view.backgroundColor = HT_BG_COLOR;
    
    if ([_vcType isEqualToString:@"home"]) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth) style:UITableViewStylePlain];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64) style:UITableViewStylePlain];
    }
    
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView registerNib:[UINib nibWithNibName:@"JiaoYiRecordCell" bundle:nil] forCellReuseIdentifier:ID];
}


@end

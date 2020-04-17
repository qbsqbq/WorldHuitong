//
//  InvestDetaileController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "InvestDetaileController.h"
#import "InvestDetaileHeadCell.h"
#import "InvestMiddleCell.h"
#import "InvestFoodCell.h"
#import "BiaoDate.h"                 //标期模型
#import "ZiJingDaoZahngController.h"
@interface InvestDetaileController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *biaoDates;

@end

@implementation InvestDetaileController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self creatTableView];
    
    [self loadDeatailData];
    
    [self loadDeatailListData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
       return  _biaoDates.count;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
       return  [InvestDetaileHeadCell InvestDetaileHeadCell:tableView Modle:_biao];
    }
    if (indexPath.section == 1) {
        
       InvestMiddleCell *cell = [InvestMiddleCell InvestMiddleCell:tableView Modle:_biao];
        [cell.checkProtoc addTarget:self action:@selector(checkProtocAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

    return [InvestFoodCell InvestFoodCell:tableView Modle:_biaoDates[indexPath.row]];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 334;
    }if (indexPath.section == 1){
        return 199;
    }
    return 180;
}

-(void)creatTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.navigationItem.title =  @"收款详情";
    self.view.backgroundColor=  HT_BG_COLOR;
}

-(void)loadDeatailData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"borrow",
                          @"q":@"get_view_one",
                          @"method":@"get",
                          @"fields":@"receive",
                          @"borrow_nid":_biao.borrow_nid,
                          @"user_id":[Tools HtUserId],
                          @"id":[NSNumber numberWithInt:_biao.inveterId]
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
    
//       NSLog(@"%@",response);
        
        [_biao setValuesForKeysWithDictionary:response];
        [[Tools shareTools]hidenHud];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];
//        NSLog(@"%@",error);
        
    }];


}

-(void)loadDeatailListData
{
    NSDictionary *dic = @{
                          @"module":@"borrow",
                          @"q":@"get_recover_list",
                          @"method":@"get",
                          @"fields":@"recover",
                          @"borrow_nid":_biao.borrow_nid,
                          @"user_id":[Tools HtUserId],
                          @"id":[NSNumber numberWithInt:_biao.inveterId],
                          @"order":@"recover_period"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
    
//   NSLog(@"%@",response);
    
    //将字典数组转为模型数组
    _biaoDates = [BiaoDate mj_objectArrayWithKeyValuesArray:response[@"list"]];
    [self.tableView reloadData];
    
    
    } fail:^(NSError *error) {
    }];

}


//查看借款协议
-(void)checkProtocAction
{
    ZiJingDaoZahngController *protocVC = [[ZiJingDaoZahngController alloc]init];
    BiaoDate *biao = _biaoDates[0];
    NSString *str1 = @"https://www.huitongp2p.com/?ajax&t=users_protocol&&borrow_nid=";
    NSString *str2 = @"&type=";
    NSString *str3 = @"&urltype=ios";
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",str1,_biao.borrow_nid,str2,biao.borrow_type,str3];
    
    protocVC.url = url;
    protocVC.headTitle = @"借款协议";
    [self.navigationController pushViewController:protocVC animated:YES];

}
@end

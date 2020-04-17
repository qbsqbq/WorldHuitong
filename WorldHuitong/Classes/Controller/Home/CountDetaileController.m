//
//  CountDetaileController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "CountDetaileController.h"
#import "CountDetaileCell.h"
@interface CountDetaileController ()
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation CountDetaileController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self creatTableView];
}


#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _replayments.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CountDetaileCell CountDetaileCellWithModle:_replayments[indexPath.row] RepaymentText:_repaymentType];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 208;
}


-(void)creatTableView
{
    if ([_vcType isEqualToString:@"home"]) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth )];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64)];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];

}

@end

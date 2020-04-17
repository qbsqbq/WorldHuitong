//
//  SucessViewController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "SucessViewController.h"
#import "ScuessCell.h"
@interface SucessViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation SucessViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self layoutTableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScuessCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ScuessCell" owner:self options:nil] lastObject];
    [[HTView shareHTView]setView:cell.bg_viw cornerRadius:4];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)layoutTableView
{
    self.navigationItem.title = @"注册成功";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

}

@end

//
//  TradersPwController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//交易密码

#import "TradersPwController.h"
#import "TradersPassWordView.h"
@interface TradersPwController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)TradersPassWordView *head;

@end

@implementation TradersPwController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self creatTableView];

    
}


#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"passWord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _head = [[[NSBundle mainBundle] loadNibNamed:@"TradersPassWordView" owner:self options:nil] lastObject];
    
    _head.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64);
    [_head.shureTraders addTarget:self action:@selector(shureTradersAction) forControlEvents:UIControlEventTouchUpInside];
    
    return _head;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;

}

//联系客服
-(void)shureTradersAction
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"拨打电话修改交易密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"400-168-0111",@"0951-5085544", nil];
     [action showInView:self.view];
   
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
       
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-168-0111"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }else{
    
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"0951-5085544"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }

}

-(void)creatTableView
{
    self.view.backgroundColor = HT_BG_COLOR;
    self.navigationItem.title = @"修改交易密码";
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
}



@end

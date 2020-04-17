//
//  RealNameResultController.m
//  WorldHuitong
//
//  Created by TXHT on 16/7/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RealNameResultController.h"
#import "RealNameResultView.h"
@interface RealNameResultController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)RealNameResultView *head;
@end

@implementation RealNameResultController

-(RealNameResultView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"RealNameResultView" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth, 200);
        [[HTView shareHTView]setView:_head.bg_view cornerRadius:4];
        
        
        if([_realNameState isEqualToString:@"0"]){
            _head.renzhengState.text = @"审核中...";
        }else{
            _head.renzhengState.text = @"审核成功";
        }
        
        _head.realName.text = [NSString stringWithFormat:@"%@*",[_realName substringToIndex:1]];
        _head.persinId.text = _personID;
        
        
    }
    return _head;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"实名认证";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.tableFooterView = [[UIView alloc]init];
}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"phoneResult";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.head;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{return 200;}



@end

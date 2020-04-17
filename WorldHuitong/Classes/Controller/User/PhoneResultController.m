//
//  PhoneResultController.m
//  WorldHuitong
//
//  Created by TXHT on 16/7/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "PhoneResultController.h"
#import "PhoneResuleView.h"
#import "RemovePhoneController.h"
@interface PhoneResultController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)PhoneResuleView *head;
@end

@implementation PhoneResultController
-(PhoneResuleView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"PhoneResuleView" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth, 200);
        [[HTView shareHTView]setView:_head.bg_view cornerRadius:4];
        [[HTView shareHTView]setView:_head.changePW cornerRadius:4];
        NSString *phone = [NSString stringWithFormat:@"%@****%@",[_phoneNumber substringToIndex:3],[_phoneNumber substringWithRange:NSMakeRange(7, 4)]];
        _head.phoneNumber.text = phone;
        [_head.changePW addTarget:self action:@selector(changePWAction) forControlEvents:UIControlEventTouchUpInside];
        
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
    self.navigationItem.title = @"修改手机号码";
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


//修改密码
-(void)changePWAction
{
    RemovePhoneController *removePhone = [[RemovePhoneController alloc]init];
    [self.navigationController pushViewController:removePhone animated:YES];
}
@end

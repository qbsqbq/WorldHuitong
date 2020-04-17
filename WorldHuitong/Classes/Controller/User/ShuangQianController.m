//
//  ShuangQianController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "ShuangQianController.h"
#import "ShuangQianView.h"
#import "GTMBase64.h"  //Base64加解密
#import "RegShuangQianViewController.h"
@interface ShuangQianController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *shuangQianUrl;
@property(nonatomic,strong)ShuangQianView *head;


@end

@implementation ShuangQianController

-(ShuangQianView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"ShuangQianView" owner:self options:nil]lastObject];
        _head.icon.image = [UIImage imageNamed:@"user_center_ShQ"];
        [[HTView shareHTView]setView:_head.bg_view cornerRadius:4];
        _head.dredgShuangQian.backgroundColor = HT_COLOR;
        [_head.dredgShuangQian addTarget:self action:@selector(dredgShuangQianAction) forControlEvents:UIControlEventTouchUpInside];
        [[HTView shareHTView]setView:_head.dredgShuangQian cornerRadius:3];
        
        if ([_open isEqualToString:@"error"]) {
            
            _head.dredgState.textColor = [UIColor redColor];
            _head.dredgState.text = @"未开通";
            
        }else if([_open isEqualToString:@"success"]){
            
            _head.dredgState.text = @"已开通";
            _head.dredgState.textColor = HT_TCOLOR;
            
        }
    }
    return _head;


}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    [self customTableView];
    
}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
{
    return self.view.bounds.size.height / 2;
}



/**开通双乾**/
-(void)dredgShuangQianAction
{
    NSString *inforStr = [[Tools shareTools]dictionaryToJson:@{@"client_type":@"IOS"}];
    NSString *infor = [GTMBase64 encodeBase64String:inforStr];
    [[Tools shareTools]progressWithTitle:@"请稍后..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"trust",
                          @"q":@"reg",
                          @"method":@"post",
                          @"user_id":[Tools HtUserId],
                          @"info":infor
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};

    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
        [[Tools shareTools]hidenHud];
        NSString *url = response[@"data"][@"url"];
//       NSLog(@"response=====%@",response);
        
        if ([response[@"result"] isEqualToString:@"success"]) {
           
            RegShuangQianViewController *regSshangQian = [[RegShuangQianViewController alloc]init];
            NSString *baseUrl = [GTMBase64 decodeBase64String:url];
            NSString *utf8Url = [baseUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            regSshangQian.url = utf8Url;
            regSshangQian.alterTitle = @"恭喜您,双乾托管开通成功";
            [self.navigationController pushViewController:regSshangQian animated:YES];
       
        }else{
   
            [Tools alterWithTitle:response[@"error_remark"]];
        }

    } fail:^(NSError *error) {
       
        [[Tools shareTools]hidenHud];
    }];
    
}

-(void)customTableView
{
    self.navigationItem.title = @"开通双乾托管";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];

}



@end

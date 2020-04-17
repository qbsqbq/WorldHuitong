//
//  RecommendRulesController.m
//  ；
//
//  Created by TXHT on 16/4/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RecommendRulesController.h"
#import "NSString+Category.h"
@interface RecommendRulesController ()
@property(nonatomic,strong)NSString *str;
@end

@implementation RecommendRulesController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"推荐规则";
    
    _str = @"1、邀请好友或其他朋友注册成功，即可建立推广关系；\n2、好友或其他朋友累计投资额超过1万，可送100元投资红包至您账户，红包可累计多次，但同一被邀请用户仅可提供一次红包；";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommedRules" forIndexPath:indexPath];
    if (!cell) {
       cell = [[UITableViewCell alloc]init];
    }
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc]init];
    head.frame = CGRectMake(10, 10, kScreenWidth - 20, kScreenHeigth - 64);
    //
    UILabel *lable = [[UILabel alloc]init];
    lable.frame = CGRectMake(10, 10, kScreenWidth - 20, [_str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kScreenWidth - 20, 10000)] + 80);
    lable.text = [NSString stringWithFormat:@"%@",_str];
    lable.numberOfLines = 0;
    [head addSubview:lable];
    return head;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

@end

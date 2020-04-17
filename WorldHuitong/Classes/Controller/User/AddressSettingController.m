//
//  AddressSettingController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "AddressSettingController.h"
#import "AddAddressController.h"
@interface AddressSettingController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSArray *contexts;
@property(nonatomic,strong)UIButton *defaultBtn;



@end

@implementation AddressSettingController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatSubsViews];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            cell.textLabel.text = _titles[indexPath.row];
            cell.detailTextLabel.text = _contexts[indexPath.row];
        }if (indexPath.section == 1) {
            UILabel *deleteLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            [cell.contentView addSubview:deleteLable];
            deleteLable.text = @"删除该地址";
            deleteLable.font = [UIFont systemFontOfSize:15];
            deleteLable.textAlignment = NSTextAlignmentCenter;
            deleteLable.textColor = [UIColor redColor];
        }
    
    }
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //删除地址
        [self deleteAddress];
    }

}
//修改地址
-(void)modifyAddress
{
    AddAddressController *addAddress = [[AddAddressController alloc]init];
    addAddress.address = _address;
    addAddress.naTitle = @"修改收货地址";
    [self.navigationController pushViewController:addAddress animated:YES];
}

//设置为默认地址
-(void)defaultSetting
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                         @"module":@"goods",
                         @"q":@"update_address",
                         @"method":@"post",
                         @"id":_address.ID,
                         @"user_id":[Tools HtUserId],
                         @"consignee":[Tools utf8:_address.consignee],
                         @"prov":[Tools utf8:_address.prov],
                         @"city":[Tools utf8:_address.city],
                         @"dist":[Tools utf8:_address.dist],
                         @"street":[Tools utf8:_address.street],
                         @"zip_code":_address.zip_code,
                         @"phone":_address.phone,
                         @"defult_address":@"1"
                         };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
        [[Tools shareTools]hidenHud];
//        NSLog(@"******%@",response);
        if ([response[@"result"] isEqualToString:@"success"]) {
            
            [[Tools shareTools]progressWithTitle:@"设置默认地址成功" Image:kTimage OnView:self.view Hide:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [Tools alterWithTitle:response[@"error_remark"]];
        }
    } fail:^(NSError *error) {
        [[Tools shareTools]hidenHud];

        NSLog(@"%@",error);
        
    }];



}

-(void)creatSubsViews
{
    self.title = @"收货地址设置";
    self.view.backgroundColor = HT_BG_COLOR;
    [self.view addSubview:self.tableView];
    _titles = @[@"收货人",@"手机号",@"派送地址",@"邮政编码"];
    NSString *addre = [NSString stringWithFormat:@"%@%@%@%@",_address.prov,_address.city,_address.dist,_address.street];
    _contexts = @[_address.consignee,_address.phone,addre,_address.zip_code];
    
    if ([_address.is_default isEqualToString:@"1"]) {
      
        _defaultBtn.hidden = YES;
    }else{
        //设为默认按钮
        _defaultBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 70, self.view.bounds.size.height - 140 , 140, 44)];
        _defaultBtn.backgroundColor = HT_COLOR;
        [[HTView shareHTView]setView:_defaultBtn cornerRadius:4];
        [_defaultBtn addTarget:self action:@selector(defaultSetting) forControlEvents:UIControlEventTouchUpInside];
        [_defaultBtn setTitle:@"设置为默认地址" forState:UIControlStateNormal];
        [self.view addSubview:_defaultBtn];
    }
    
    //修改
    UIBarButtonItem *rigthBar = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(modifyAddress)];
    self.navigationItem.rightBarButtonItem = rigthBar;
}

//删除地址
-(void)deleteAddress
{
   
    NSDictionary *dic = @{
                          @"module":@"goods",
                          @"q":@"delete_address",
                          @"method":@"post",
                          @"user_id":[Tools HtUserId],
                          @"id":_address.ID
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//        NSLog(@"******%@",response);
        if ([response[@"result"] isEqualToString:@"success"]) {
            
            [[Tools shareTools]progressWithTitle:@"删除地址成功" Image:kTimage OnView:self.view Hide:1.5];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [Tools alterWithTitle:response[@"error_remark"]];
        }
    } fail:^(NSError *error) {

        NSLog(@"%@",error);

    }];

}

@end

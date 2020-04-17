//
//  AddressManageController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "AddressManageController.h"
#import "AddAddressController.h"
#import "AddressSettingController.h"
#import "ChooseAddressCell.h"
#import "Address.h"
@interface AddressManageController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *addresses;

@end

@implementation AddressManageController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth -14)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavigationBar];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadAddressData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addresses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseAddressCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ChooseAddressCell" owner:self options:nil] lastObject];
    [cell.isifSelected setImage:[UIImage imageNamed:@"jiantou_r"] forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bg_view.backgroundColor = HT_BG_COLOR;
    
    Address *address = _addresses[indexPath.row];
    cell.userName.text = address.consignee;
    cell.phoneNum.text = address.phone;
    cell.userAddress.text = [NSString stringWithFormat:@"%@%@%@%@",address.prov,address.city,address.dist,address.street];
    cell.theCode.text = address.zip_code;

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressSettingController *addSet = [[AddressSettingController alloc]init];
    addSet.address = _addresses[indexPath.row];
    [self.navigationController pushViewController:addSet animated:YES];
}

//添加新的收获地址
-(void)addNewAddress
{
    AddAddressController *addNew = [[AddAddressController alloc]init];
    [self.navigationController pushViewController:addNew animated:YES];
}

-(void)setNavigationBar
{
    self.view.backgroundColor = HT_BG_COLOR;
    self.title = @"地址管理";
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rigthBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"address_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewAddress)];
    self.navigationItem.rightBarButtonItem = rigthBar;


}

-(void)loadAddressData
{
    NSDictionary *dic = @{
                          @"module":@"goods",
                          @"q":@"get_address_list",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId]
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//        NSLog(@"%@",response[@"list"]);
        
        
        _addresses = [Address mj_objectArrayWithKeyValuesArray:response[@"list"]];
        [_tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
    
}

@end

//
//  ChooseAddressController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "ChooseAddressController.h"
#import "ChooseAddressCell.h"
#import "AddAddressController.h"
#import "AddressManageController.h"
#import "Address.h"

@interface ChooseAddressController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *addresses;
@end

@implementation ChooseAddressController

-(void)retunModle:(RetunModleBlock )addBlcok
{
    self.block = addBlcok;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavigationBar];
    
}

#pragma ----UITableViewDataSource-----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addresses.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   ChooseAddressCell *cell =  [[[NSBundle mainBundle]loadNibNamed:@"ChooseAddressCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bg_view.backgroundColor = HT_BG_COLOR;
    
    Address *address = _addresses[indexPath.row];
    cell.userName.text = address.consignee;
    cell.phoneNum.text = address.phone;
    cell.userAddress.text = [NSString stringWithFormat:@"%@%@%@%@",address.prov,address.city,address.dist,address.street];
    cell.theCode.text = address.zip_code;
    if ([address.is_default isEqualToString:@"1"]) {
        [cell.isifSelected setImage:[UIImage imageNamed:@"Detail_icon_succeed"] forState:UIControlStateNormal];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.block != nil) {
        self.block(_addresses[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//管理
-(void)managementAddress
{
    AddressManageController *addressMag = [[AddressManageController alloc]init];
    [self.navigationController pushViewController:addressMag animated:YES];
}

//快速添加地址
- (IBAction)addNewAddressFast:(id)sender
{
    
    AddAddressController *addAddress = [[AddAddressController alloc]init];
    [self.navigationController pushViewController:addAddress animated:YES];
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

-(void)viewWillAppear:(BOOL)animated
{
    [self loadAddressData];
}

-(void)setNavigationBar
{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.title = @"选择收货地址";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *rigthBar = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(managementAddress)];
    self.navigationItem.rightBarButtonItem = rigthBar;

}

@end

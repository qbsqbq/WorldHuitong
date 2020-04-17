//
//  OrderFillController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "OrderFillController.h"
#import "OrderFillCell.h"
#import "OrderAddressCell.h"
#import "MyInterOrderController.h"
#import "ChooseAddressController.h"
@interface OrderFillController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**实际付款**/
@property (weak, nonatomic) IBOutlet UILabel *actualPayment;
@property(nonatomic,strong)Address *address;
@property(nonatomic,assign)BOOL isRfesh;


@end

@implementation OrderFillController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatTableView];
    
    [self loadDefultAddressData];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _isRfesh = NO;

}


-(void)viewWillAppear:(BOOL)animated
{
    if (_isRfesh) {
    
    }else{
    
        [self loadDefultAddressData];
    }
 
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isRfesh = NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if (_address) {   // 有地址
            OrderAddressCell *cell= [[[NSBundle mainBundle]loadNibNamed:@"OrderAddressCell" owner:self options:nil]lastObject];
            cell.backgroundColor = RGBA_COLOR(95, 96, 108, 1);
            ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.userName.text = _address.consignee;
            cell.phone.text = _address.phone;
            cell.detaileAddress.text = [NSString stringWithFormat:@"%@%@%@%@",_address.prov,_address.city,_address.dist,_address.street];
            return cell;
        }else{           //无地址
        }
    }

  
    static NSString *ID = @"cell";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!Cell) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        Cell.backgroundColor = RGBA_COLOR(95, 96, 108, 1);
        if (_address) {
            Cell.textLabel.text = @"选择收货地址";

        }else{
            Cell.textLabel.text = @"添加收货地址";

        }
        Cell.textLabel.font = [UIFont systemFontOfSize:17];
        Cell.textLabel.textColor = [UIColor whiteColor];
        Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 2) {
        return [OrderFillCell orderFillCellWithModle:_shop];
    }
    if (indexPath.row == 3) {
        Cell.textLabel.text = @"数量";
        Cell.textLabel.font = [UIFont systemFontOfSize:14];
        Cell.textLabel.textColor = RGBA_COLOR(95, 96, 108, 1);
        Cell.detailTextLabel.text = [NSString stringWithFormat:@"x%d",_shopNumber];
        Cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return Cell;
 

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if (!_address) {
            return 0;
        }else{
            return 100;
        }
    }
    if (indexPath.row == 2) {
        return 160;
    }
    return 50;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ChooseAddressController *chooseAddress = [[ChooseAddressController alloc]init];
        
        [chooseAddress retunModle:^(Address *address) {
            _address = address;
            _isRfesh = YES;
            [self.tableView reloadData];
        }];
        
        [self.navigationController pushViewController:chooseAddress animated:YES];
    }
}

//立即支付
- (IBAction)lijiPay:(id)sender
{
    if (!_address.ID) {
        [Tools alterWithTitle:@"用户的地址为空\n请添加收货地址"];
    }else{
    
        [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
        NSDictionary *dic = @{
                              @"module":@"goods",
                              @"q":@"pay",
                              @"method":@"post",
                              @"user_id":[Tools HtUserId],
                              @"goods_num":_shop.goods_num,
                              @"num":[NSString stringWithFormat:@"%d",_shopNumber],
                              @"address_id":_address.ID
                              };
        NSString *str = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:str];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:YES params:par success:^(id response) {
            [[Tools shareTools]hidenHud];
            //       NSLog(@"%@",response);
            
            if ([response[@"result"] isEqualToString:@"error"]) {
                
                [Tools alterWithTitle:response[@"error_remark"]];
            }else{
                
                [[Tools shareTools]progressWithTitle:@"支付成功" Image:kTimage OnView:self.view Hide:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    MyInterOrderController *mio = [[MyInterOrderController alloc]init];
                    [self.navigationController pushViewController:mio animated:YES];
                });
            }
            
        } fail:^(NSError *error) {
            
            [[Tools shareTools]hidenHud];
            
        }];

    }
    
    



}

//获取默认地址
-(void)loadDefultAddressData
{
    NSDictionary *dic = @{
                          @"module":@"goods",
                          @"q":@"get_address_one",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId]
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:YES params:par success:^(id response) {


//       NSLog(@"%@",response);
        if ([response[@"result"] isEqualToString:@"error"]) {
            
        }else{
            _address = [Address mj_objectWithKeyValues:response];
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [[Tools shareTools]hidenHud];
    }];
    
}

-(void)creatTableView
{
    //实际付款
    NSString *payStr = [NSString stringWithFormat:@"%.f积分",_shopNumber * [_shop.group_integral doubleValue]];
    _actualPayment.attributedText = [HTView setLableColorText:payStr loc:2 Color:[UIColor scrollViewTexturedBackgroundColor] FontOfSize:12];
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    self.title = @"订单填写";

}

@end

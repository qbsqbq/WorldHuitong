//
//  ShopingListController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "ShopingListController.h"
#import "ShopListCell.h"
#import "Shop.h"
#import "UIImageView+WebCache.h"
#import "JIfenExchangController.h"
@interface ShopingListController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *shops;
@property(nonatomic)NSString *pages;

             /**选择器**/
@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIPickerView* secPickView;
@property (nonatomic, strong) UIView* selectView;
@property (nonatomic, strong) UIButton* sureBtn;
@property (nonatomic, strong) UIButton* cancelBtn;
@property (nonatomic, strong) NSArray* jifens;
@property (nonatomic, strong) UIButton *allBtn;



@end

@implementation ShopingListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.view];

    _pages = @"10";
    
    [self cleartTableView];

    [self loadShopingListData];
    
    [self refreshData];
    
}




#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shops.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopListCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopListCell" owner:self options:nil] lastObject];
    Shop *shop = _shops[indexPath.row];
    cell.shopName.text = shop.goods_name;
    NSString *image = [NSString stringWithFormat:@"%@%@",kBaseImageUrl,shop.thumb];
    [cell.shopIcon sd_setImageWithURL:[NSURL URLWithString:image]];
    NSString *jifenStr = [NSString stringWithFormat:@"%@积分",shop.group_integral];
    cell.jifenNumbe.attributedText = [HTView setLableColorText:jifenStr loc:2 Color:[UIColor lightGrayColor]FontOfSize:12];
    cell.nomarPrice.text = [NSString stringWithFormat:@"市场参考价:%@元",shop.market_price];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JIfenExchangController *exchage = [[JIfenExchangController alloc]init];
    Shop *shop = _shops[indexPath.row];
    exchage.goodsnum = shop.goods_num;
    [self.navigationController pushViewController:exchage animated:YES];

}
#pragma ----UIPickerViewDataSource----


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.jifens.count;
}

#pragma mark 实现协议UIPickerViewDelegate方法
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *jifen = self.jifens[row];
    return jifen;
}


//商品列表
-(void)loadShopingListData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"goods",
                          @"q":@"get_list",
                          @"method":@"get",
                          @"goods_cate":_main_num,
                          @"epage":_pages,
                          @"page":@"1",
                          @"valid":@"1"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//      NSLog(@"******%@",response);
        _shops = [[NSArray alloc]init];
        _shops = [Shop mj_objectArrayWithKeyValuesArray:response[@"list"]];
        [self.tableView reloadData];
        
        
        [[Tools shareTools]hidenHud];
        [_tableView.mj_header endRefreshing];
        
        if ([response[@"total"] intValue] == _shops.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];
        [_tableView.mj_header endRefreshing];

    }];
    
}

//刷新与加载
-(void)refreshData
{
    //上拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [HTView isWiffOnView:self.view];
        [self loadShopingListData];
    }];
    
    //下拉加载更多
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pages = [NSString stringWithFormat:@"%d",[_pages intValue] + 10];
        [HTView isWiffOnView:self.view];
        [self loadShopingListData];
    }];

}

-(void)cleartTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = _nav_title;

}




@end

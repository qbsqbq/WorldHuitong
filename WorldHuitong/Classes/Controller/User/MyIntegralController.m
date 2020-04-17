//
//  MyIntegralController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/31.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//


#define postImageUrl @"https://www.huitongp2p.com/api/upload.php"
#import "MyIntegralController.h"
#import "MyIntegralView.h"
#import "JifenExchangeCell.h"
#import "MyIntergralDetaileController.h"
#import "ShopingListController.h"
#import "MyInterOrderController.h"
#import "UIImageView+WebCache.h"
#import "EmptyView.h"
#import "GTMBase64.h"
@interface MyIntegralController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MyIntegralView *integralView;
@property(nonatomic,strong)AppDelegate *app;

@property(nonatomic,assign)int integral_all;
@property(nonatomic,assign)int integral_can;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *myOrderBtn;

@property(nonatomic,strong)NSArray *iconArr;
@property(nonatomic,strong)NSArray *shopType;
@property(nonatomic,strong)NSMutableArray *main_nums;



@end



@implementation MyIntegralController

-(MyIntegralView *)integralView
{
    if (!_integralView) {
            _integralView = [[[NSBundle mainBundle]loadNibNamed:@"MyIntegralView" owner:self options:nil] lastObject];
        [[HTView shareHTView]setView: _integralView.bg_view cornerRadius:3];
    
        _integralView.userInteractionEnabled = YES;
        [_integralView.userIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)]];
    }
    return _integralView;
    
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatTableView];

    [HTView isWiffOnView:self.view];
    
    //积分数据
    [self loadIntergralData];
    
    //商品分类
    [self shopingCategra];
}


#pragma ----UITableViewDataSource----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _iconArr.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JifenExchangeCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JifenExchangeCell" owner:self options:nil] lastObject];
    
    cell.shopTypeIcon.image = [UIImage imageNamed:_iconArr[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self.integralView.jifenDetaiBtn addTarget:self action:@selector(jifenDetaiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.integralView.zhuanJifenBtn addTarget:self action:@selector(zhuanJifenAction) forControlEvents:UIControlEventTouchUpInside];
    
    //头像
    NSString *avatar_url = [[NSUserDefaults standardUserDefaults]valueForKey:@"avatar_url"];
    NSString *img = [NSString stringWithFormat:@"%@%@",kBaseImageUrl,avatar_url];
    [self.integralView.userIcon sd_setImageWithURL:[NSURL URLWithString:img]placeholderImage:[UIImage imageNamed:@"myinter_icon"]];
    self.integralView.userIcon.layer.cornerRadius = 30;
    self.integralView.userIcon.layer.masksToBounds = YES;
    self.integralView.userIcon.contentMode = UIViewContentModeScaleAspectFill;
    
    //用户名
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    if ([userName length] == 11) {
        self.integralView.userName.text = [NSString stringWithFormat:@"%@***%@",[userName substringToIndex:3],[userName substringFromIndex:7]];
    }else{
        self.integralView.userName.text = userName;
    }
    
    //vip
    NSString *vip_status = [[NSUserDefaults standardUserDefaults]valueForKey:@"vip_status"];
    if (vip_status) {
        
        if (![vip_status isEqualToString:@"0"]) {
        self.integralView.isVip.image = [UIImage imageNamed:@"user_vip"];
    }
    }
    
    //积分
    self.integralView.all_integral.text = [NSString stringWithFormat:@"%d",_integral_all];
    self.integralView.can_integral.text = [NSString stringWithFormat:@"%d",_integral_can];;
    
    
    return self.integralView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenWidth - 20) / 2.8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.integralView.jifenHuanLable.frame.origin.y + 24;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![Tools isConnectionAvailable]) {
       
        [HTView isWiffOnView:self.view];
    }else{
        if (_main_nums) {
            self.hidesBottomBarWhenPushed = YES;
            ShopingListController *shopList = [[ShopingListController alloc]init];
            shopList.main_num = _main_nums[indexPath.row];
            shopList.nav_title = _shopType[indexPath.row];
            [self.navigationController pushViewController:shopList animated:YES];
        }
    }
}

//积分数据
-(void)loadIntergralData
{

    NSDictionary *dic = @{
                          @"module":@"credit",
                          @"q":@"get_one_user_integral",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId],
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {

//        NSLog(@"%@",response);
        _integral_all = [response[@"all"] intValue];
        _integral_can = [response[@"can"] intValue];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } fail:^(NSError *error) {
       
        [self.tableView.mj_header endRefreshing];
        
    }];

}

/**
 * 上传头像
 */
-(void)tapImageView
{

    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择一张照片", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 设置代理
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [ipc.navigationBar setTitleTextAttributes:dic];
    ipc.navigationBar.barTintColor = HT_COLOR;
    ipc.navigationBar.tintColor =[UIColor whiteColor];  //设置返回箭头的颜色
    
        switch (buttonIndex) {
            case 0: { // 拍照
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
                ipc.sourceType = UIImagePickerControllerSourceTypeCamera;

                [self presentViewController:ipc animated:YES completion:nil];
    
                break;
            }
            case 1: { // 相册
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                    return;
                
                ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:ipc animated:YES completion:nil];
    
                break;
            }
            default:
                break;
        }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   
    //获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.integralView.userIcon.image = image;
    self.integralView.userIcon.contentMode =  UIViewContentModeScaleAspectFill;
    NSData *data = UIImageJPEGRepresentation(image, 0.1f);
    NSString *baseImage = [GTMBase64 stringByEncodingData:data];

    //传给服务器
    NSDictionary *par = @{
                          @"user_id":[Tools HtUserId],
                          @"image":[baseImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          @"suffixes":@"jpg"
                          };
    
    [HYBNetworking postWithUrl:postImageUrl refreshCache:NO params:par success:^(id response) {
        
        [[Tools shareTools]progressWithTitle:@"头像已设置成功" Image:kTimage OnView:self.view Hide:1.5];
        
    } fail:^(NSError *error) {
        
    }];

    
    [picker dismissViewControllerAnimated:YES completion:NULL];

    
    
}


 //商品分类
-(void)shopingCategra
{
    NSDictionary *dic = @{
                          @"module":@"goods",
                          @"q":@"get_cate_list",
                          @"method":@"get",
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//    NSLog(@"******%@",response);
        
        _main_nums = [[NSMutableArray alloc]init];
        
        NSArray *arr = response[@"data"][@"main"];
        for (NSDictionary *dic in arr) {
            [_main_nums addObject:dic[@"main_num"]];
        }
    } fail:^(NSError *error) {
        
    }];

}

-(void)creatTableView
{
    
    self.navigationItem.title = @"";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeigth + 54) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    

    //添加返回按钮
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 44)];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImage:[UIImage imageNamed:@"na_back"] forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
    
    //我的订单
    _myOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 20, 70, 44)];
    [_myOrderBtn addTarget:self action:@selector(myOrderAction) forControlEvents:UIControlEventTouchUpInside];
    _myOrderBtn.titleLabel.textColor = [UIColor blackColor];
    _myOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_myOrderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [self.view addSubview:_myOrderBtn];
    
    
    _iconArr = @[@"shop_icon1",@"shop_icon2",@"shop_icon3",@"shop_icon4",@"shop_icon5",@"shop_icon6",@"shop_icon7",@"shop_icon8"];
    _shopType = @[@"厨具/餐具",@"家具/日用",@"数码/生活",@"车用/车饰",@"时尚/运动",@"儿童/母婴",@"商旅/书刊",@"虚拟物品"];
}

//积分明细
-(void)jifenDetaiAction
{
    self.hidesBottomBarWhenPushed = YES;
    MyIntergralDetaileController *mid = [[MyIntergralDetaileController alloc]init];
    mid.pageType = _pageType;
    [self.navigationController pushViewController:mid animated:YES];
}

//投资赚积分
-(void)zhuanJifenAction
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.app = (AppDelegate*)[[UIApplication sharedApplication]delegate] ;
    self.app.tabBarVC.selectedIndex = 1;

}


/**
 *  返回
 */
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  我的订单
 */
-(void)myOrderAction
{
    self.hidesBottomBarWhenPushed = YES;
    MyInterOrderController *mio = [[MyInterOrderController alloc]init];
    mio.pageType = _pageType;
    [self.navigationController pushViewController:mio animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    //隐藏navigationBar
    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBarHidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
}

@end

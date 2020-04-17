//
//  TenderDetailController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/8.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "TenderDetailController.h"

//ShareSDK头文件
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#import "TenderDetailCell.h"
#import "TenderDetailView.h"
#import "DetaileBiao.h"
#import "JiaoYiRecordController.h"  //交易记录
#import "TouZiController.h"         //投资
#import "CounterController.h"       //计算器
#import "BaseInForController.h"     //基本信息
#import "BiaoIntroduceController.h" //借款标介绍
#import "ImageBrowseViewController.h"//相册
#import "ZiJingDaoZahngController.h" //资金到账
#import "RegisterController.h"
#import "User.h"
@interface TenderDetailController ()
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)DetaileBiao *detaileBiao;
@property(nonatomic,strong)User *user;
@property(nonatomic,strong)NSMutableArray *upfiles_pics;      //项目材料的urls
@property(nonatomic,strong)NSString *borryedName;             //借款人姓名
@property(nonatomic,strong)NSString *borrow_times;            //发布借款次数
@property(nonatomic,strong)NSString *userName;                //发布人
@property(nonatomic,strong)UIImageView *backImage;


/**立即投资**/
@property (weak, nonatomic) IBOutlet UIButton *LiJiInvestment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)TenderDetailView *head;


@end

@implementation TenderDetailController


-(TenderDetailView *)head
{
    if (!_head) {
        _head  = [TenderDetailView tenderDelViewWithModle:_biao];
        
        //查看资金到账
        [_head.lookDetaile addTarget:self action:@selector(lookDetaileData) forControlEvents:UIControlEventTouchUpInside];
        
        //基本信息
        [_head.asicInfo addTarget:self action:@selector(BasicInfo) forControlEvents:UIControlEventTouchUpInside];
        
        //借款标介绍
        [_head.introduce addTarget:self action:@selector(introduce) forControlEvents:UIControlEventTouchUpInside];
        
        //项目材料
        [_head.material addTarget:self action:@selector(material) forControlEvents:UIControlEventTouchUpInside];
        
        //交易记录
        [_head.transaction addTarget:self action:@selector(transaction) forControlEvents:UIControlEventTouchUpInside];
        
        //注册送礼
        [_head.regBtb addTarget:self action:@selector(regestAction) forControlEvents:UIControlEventTouchUpInside];
        
        //立即投资按钮
        [[HTView shareHTView]setView:_LiJiInvestment cornerRadius:4];
        _LiJiInvestment.enabled = YES;
        _LiJiInvestment.backgroundColor = HT_COLOR;
        [_head.lookDetaile setTitleColor:HT_COLOR forState:UIControlStateNormal];
         [_head.lookDetaile setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        
        
        if (kUSER_ID) {
            _head.regBtb.enabled = NO;
            _head.regBtb.backgroundColor = [UIColor lightGrayColor];
        }else{
            _head.regBtb.enabled = YES;
            _head.regBtb.backgroundColor = [UIColor redColor];
        }
    }
    return _head;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshData];
 
    [self customNavigationBar];
    
    //隐藏tabbar
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.tabBarVC.tabBar.hidden = YES;
}


-(void)refreshData
{
    //1.自动刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDetaileData];
    }];
    
    [self.tableView.mj_header beginRefreshing];   //马上进入刷新状态
    
}
#pragma ----UITableViewDataSource-----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 0;}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CELL";
     UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    return cell;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.head;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    TenderDetailView *headView = [TenderDetailView tenderDelViewWithModle:_biao];
   
    return headView.bg_allButton.frame.origin.y + 183 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//立即投资
- (IBAction)liJiInvestment:(UIButton *)sender
{

    if (kUSER_ID) {
        self.hidesBottomBarWhenPushed = YES;
        TouZiController *touzi = [[TouZiController alloc]init];
        touzi.biao = _biao;
        touzi.detaileBiao = _detaileBiao;
        touzi.borrow_period_name = _biao.borrow_period_name;
        [self.navigationController pushViewController:touzi animated:YES];

    }else {
       
        LogController *log = [[LogController alloc]init];
        [self presentViewController:log animated:YES completion:nil];
    }
    
}

//计算器
- (IBAction)Calculator:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    CounterController *counter = [[CounterController alloc]init];
    counter.vcType = _vcType;
    [self.navigationController pushViewController:counter animated:YES];
}

//查看详细资金到账时间
-(void)lookDetaileData
{
    ZiJingDaoZahngController *detaileDvc = [[ZiJingDaoZahngController alloc]init];
    detaileDvc.headTitle= @"申请提现到账时间查询表";
    detaileDvc.url = @"https://www.huitongp2p.com/api/recommend/cash_info.php";
    detaileDvc.vcType = _vcType;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detaileDvc animated:YES];

}

//基本信息
-(void)BasicInfo
{
    if (![Tools isConnectionAvailable]) {
        [HTView isWiffOnView:self.view];
    }else{
        self.hidesBottomBarWhenPushed = YES;
        BaseInForController *baseInForVC = [[BaseInForController alloc]init];
        baseInForVC.borryerName = _borryedName;
        baseInForVC.borryer_userID = _detaileBiao.user_id;
        baseInForVC.borrow_times = _borrow_times;
        baseInForVC.vcType = _vcType;
        [self.navigationController pushViewController:baseInForVC animated:YES];
    }
}

//借款标介绍
-(void)introduce
{
    if (![Tools isConnectionAvailable]) {
        
        [HTView isWiffOnView:self.view];
    }else{
        BiaoIntroduceController *baoIntroduceVC = [[BiaoIntroduceController alloc]init];
        baoIntroduceVC.borrow_contents = _detaileBiao.borrow_contents;
        baoIntroduceVC.vcType = _vcType;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baoIntroduceVC animated:YES];
    }
}

//项目材料
-(void) material
{
    if (![Tools isConnectionAvailable]) {
       
        [HTView isWiffOnView:self.view];
    }else{
        if (_upfiles_pics.count == 0) {
            
            [Tools alterWithTitle:@"项目材料为空"];
        }else {
            
            self.hidesBottomBarWhenPushed = YES;
           ImageBrowseViewController *imageVC = [[ImageBrowseViewController alloc]initWithBrowseImages:_upfiles_pics withIndex:0];
          [self presentViewController:imageVC animated:NO completion:nil];
        }
    }
}

//交易记录
-(void)transaction
{
    JiaoYiRecordController * jiaoYiRecordVC = [[JiaoYiRecordController alloc]init];
    jiaoYiRecordVC.borrow_nid = _biao.borrow_nid;
    jiaoYiRecordVC.vcType = _vcType;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jiaoYiRecordVC animated:YES];
    
}

//注册送礼
-(void)regestAction
{
    if (kUSER_ID) {
      
    }else{
        RegisterController *regestVC = [[RegisterController alloc]init];
        [self presentViewController:regestVC animated:YES completion:nil];
    }
    
}

-(void)customNavigationBar
{
    //设置售罄的状态
    if ([_biao.borrow_account_scale floatValue] >= 100) {
        
        //设置售罄图片
        _backImage = [[UIImageView alloc]init];
        _backImage.center = self.view.center;
        _backImage.frame = CGRectMake(kScreenWidth / 2, kScreenHeigth / 3 - 40, 162, 100);
        _backImage.image = [UIImage imageNamed:@"shouqing_icon"];
        [self.head addSubview:_backImage];
        
        //设置售罄文字
        _head.scale.textColor = [UIColor lightGrayColor];
        _head.inancedScale.textColor = [UIColor lightGrayColor];
        _head.vendibilityMoney.textColor = [UIColor lightGrayColor];
        _head.regBtb.backgroundColor = [UIColor lightGrayColor];
        _head.buyTimes.textColor = [UIColor lightGrayColor];
        _head.staryMoney.textColor = [UIColor lightGrayColor];
        _head.modeOfRepayment.textColor = [UIColor lightGrayColor];
        _head.dateOfValue.textColor = [UIColor lightGrayColor];
        _head.ZiJinDaoZhang.textColor = [UIColor lightGrayColor];
        //
        _LiJiInvestment.enabled = NO;
        _LiJiInvestment.backgroundColor = [UIColor lightGrayColor];
    }

    //
    self.navigationItem.title = _biao.name;
    self.view.backgroundColor = HT_BG_COLOR;
    UIBarButtonItem *rigthBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"]  style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    
    self.navigationItem.rightBarButtonItem = rigthBar;
}

-(void)loadDetaileData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = nil;
    
    if ([_biao.borrow_type isEqualToString:@"roam"]) {    //流转标
        dic = @{
              @"module":@"borrow",
              @"q":@"get_roam_one",
              @"method":@"get",
              @"borrow_nid":_biao.borrow_nid
              };
        NSString *str = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:str];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
            [[Tools shareTools]hidenHud];
            [self.tableView.mj_header endRefreshing];
//          NSLog(@"%@********************",response);
            
            //mj字典转模型
            _detaileBiao = [DetaileBiao mj_objectWithKeyValues:response];
            _borryedName = response[@"username"];
            
            //项目材料
            _upfiles_pics = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in response[@"upfiles_pic"]) {
                NSString *url = [NSString stringWithFormat:@"%@%@",kBaseImageUrl,dic[@"fileurl"]];
                [_upfiles_pics addObject:url];
            }
            
            [self.tableView reloadData];
            
        } fail:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            [[Tools shareTools]hidenHud];
            
        }];

    }else{                                                 //非流转标
    
        dic = @{
               @"module":@"borrow",
               @"q":@"get_view_one",
               @"method":@"get",
               @"borrow_nid":_biao.borrow_nid
               };
        NSString *str = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:str];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
            [[Tools shareTools]hidenHud];
            [self.tableView.mj_header endRefreshing];
//            NSLog(@"%@********************",response);
            
            //mj字典转模型
            _detaileBiao = [DetaileBiao mj_objectWithKeyValues:response];
            
            _borryedName = response[@"username"];
            _borrow_times = response[@"borrow_times"];
            
            //项目材料
            _upfiles_pics = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in response[@"upfiles_pic"]) {
                NSString *url = [NSString stringWithFormat:@"%@%@",kBaseImageUrl,dic[@"fileurl"]];
               [_upfiles_pics addObject:url];
            }
            
            [self.tableView reloadData];
            
        } fail:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            [[Tools shareTools]hidenHud];
            
        }];

    }
   
    


}

//分享
-(void)share:(UIBarButtonItem*)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/api/recommend/tender.php?borrow_nid=%@",kBaseImageUrl,_biao.borrow_nid];
    NSString *titleName = _biao.name;
    //创建分享内容
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@",titleName,url]
                                       defaultContent:titleName
                                                image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"share_icon"]]
                                                title:titleName
                                                  url:url
                                          description:titleName
                                            mediaType:SSPublishContentMediaTypeNews];
    //定制短信信息
    [publishContent addCopyUnitWithContent:url image:nil];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    NSArray *shareList = [[NSArray alloc]init];
 
    
    //判断微信/QQ是否安装了客户端
    if ([WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]) {
        
        //选择要添加的功能
        shareList = [ShareSDK customShareListWithType:
                     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                     SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                     SHARE_TYPE_NUMBER(ShareTypeQQ),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                     SHARE_TYPE_NUMBER(ShareTypeSMS),
                     SHARE_TYPE_NUMBER(ShareTypeCopy),
                     nil];
        
    }else if(![WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]){
        
        shareList = [ShareSDK customShareListWithType:
                     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                     SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                     SHARE_TYPE_NUMBER(ShareTypeQQ),
                     SHARE_TYPE_NUMBER(ShareTypeSMS),
                     SHARE_TYPE_NUMBER(ShareTypeCopy),
                     nil];
    }else if ([WXApi isWXAppInstalled] && ![QQApiInterface isQQInstalled]){
        shareList = [ShareSDK customShareListWithType:
                     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                     SHARE_TYPE_NUMBER(ShareTypeSMS),
                     SHARE_TYPE_NUMBER(ShareTypeCopy),
                     nil];
    }else if (![WXApi isWXAppInstalled] && ![QQApiInterface isQQInstalled]){
        shareList = [ShareSDK customShareListWithType:
                     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                     SHARE_TYPE_NUMBER(ShareTypeSMS),
                     SHARE_TYPE_NUMBER(ShareTypeCopy),
                     nil];
    }

    
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    if (type == ShareTypeCopy) {
                                        
                                        [HTView alterTitle:@"拷贝成功"];
                                    }else{
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                                        
                                        [alertView show];
                                        
                                    }
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
    
    
    
    
}



@end

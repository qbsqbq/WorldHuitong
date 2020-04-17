//
//  MyInvestController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//我的投资

#import "MyInvestController.h"
#import "JYSlideSegmentController.h" //筛选控制器
#import "MyInvestCell.h"
#import "chooseView.h"
#import "InverstedBiao.h"            //已投的标
#import "InvestDetaileController.h"
#import "EmptyView.h"
@interface MyInvestController ()

/**筛选列表**/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**蒙版按钮**/
@property(nonatomic,strong)UIButton *cancelBtnV;
@property(nonatomic,strong)UIButton *cancelBtnH;

/**弹出的viwe**/
@property(nonatomic,strong)chooseView *pushView;

/**空的图片**/
@property(nonatomic,strong)EmptyView *emptyView;



/**选中的时间的字符串**/
@property(nonatomic,strong)NSString *timeStr;

@property(nonatomic,strong)UIActionSheet *typeasheet;
@property(nonatomic,strong)UIActionSheet *stateSheet;
@property(nonatomic,assign)BOOL one;
@property(nonatomic,strong)NSString *pages;

/**数组模型**/
@property(nonatomic,strong)NSArray *biaoArr;

@property(nonatomic,strong)NSString *biaoState;  //存储标的状态
@property(nonatomic,strong)NSString *biaoType;   //存储标的类型
@property(nonatomic,strong)NSString *biaoBTime;  //存储标的开始时间
@property(nonatomic,strong)NSString *biaoETime;  //存储标的结束时间

@end

@implementation MyInvestController

-(EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc]initWithFrame:self.view.bounds Title:@"暂无投资" Image:@"touzi"];
    }
    return _emptyView;
}

/**懒加载竖直蒙版按钮**/
-(UIButton *)cancelBtnV
{
    if (!_cancelBtnV) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 64,90, kScreenHeigth)];
        [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor grayColor];
        button.alpha = 0.4;
        _cancelBtnV = button;
    }
    
    return  _cancelBtnV;
}

/**懒加载竖直蒙版按钮**/
-(UIButton *)cancelBtnH
{
    if (!_cancelBtnH) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 64)];
        [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor grayColor];
        button.alpha = 0.1;
        _cancelBtnH = button;
    }
    
    return  _cancelBtnH;
}

/**懒加载弹出试图**/
-(UIView *)pushView
{
    if (!_pushView) {
         _pushView = [[[NSBundle mainBundle] loadNibNamed:@"chooseView" owner:self options:nil] lastObject];
        _pushView.frame = CGRectMake(90, 64, kScreenWidth - 90, kScreenHeigth - 64);
        [[HTView shareHTView]setView:_pushView.bg_view cornerRadius:4];
        [[HTView shareHTView]setView:_pushView.shureBtn cornerRadius:4];
        _pushView.shureBtn.backgroundColor = HT_COLOR;
        _pushView.backgroundColor = HT_BG_COLOR;
        [_pushView.shureBtn addTarget:self action:@selector(shureAction) forControlEvents:UIControlEventTouchUpInside];
        [_pushView.timePickView addTarget:self action:@selector(timeChanage:) forControlEvents:UIControlEventValueChanged];
        [_pushView.type addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
        [_pushView.startTime addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
        [_pushView.endTime addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
        [_pushView.state addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pushView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self customNavigtionBar];
    
    [HTView isWiffOnView:self.view];
    
    //刷新tableView
    [self refreshTableView:_tableView];
    
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _biaoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [MyInvestCell MyInvestCell:tableView forIndexPath:indexPath DataArr:_biaoArr];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"InvestDetaileController" sender:indexPath];

}

//传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = (NSIndexPath*)sender;
    InvestDetaileController *InvestDetaileVC = segue.destinationViewController;
    InvestDetaileVC.biao = _biaoArr[index.row];
}

/**选择按钮**/
- (IBAction)chooseBtn:(id)sender
{
    //添加蒙版
     AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app.window addSubview:self.cancelBtnV];
    [app.window addSubview:self.cancelBtnH];
    
    [app.window addSubview:self.pushView];
}

/**移除蒙版**/
-(void)cancelAction
{
    [_cancelBtnV removeFromSuperview];
    [_cancelBtnH removeFromSuperview];
    [_pushView removeFromSuperview];
    
}

/**选择标的类型**/
-(void)changeValue:(UIButton *)btn
{
    if (btn.tag == 3001) {
        
        [self customTypeActionSheet];
    }
    if (btn.tag == 3002) {
        self.pushView.timePickView.hidden = NO;
        _one = YES;
    }
    if (btn.tag == 3003) {
        self.pushView.timePickView.hidden = NO;
        _one = NO;
    }
    if (btn.tag == 3004) {
        [self customStateActionSheet];
    }


}

-(void)timeChanage:(UIDatePicker*)pick
{
    _timeStr = [[NSString stringWithFormat:@"%@",pick.date] substringToIndex:10];
    if (_timeStr == nil) {
    }
    if (_one) {
        _pushView.startLable.text = _timeStr;
        _biaoBTime = _timeStr;
    }
    if (!_one) {
        _pushView.endLable.text = _timeStr;
        _biaoETime = _timeStr;
    }
}

/**确定筛选按钮**/
-(void)shureAction
{
    [self cancelAction];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pages = [NSString stringWithFormat:@"%d",10];
        [self chooseActionData];
    }];
    [self.tableView.mj_header beginRefreshing];

}


#pragma ----UIActionSheetDelegate----
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _typeasheet) {
        if (buttonIndex == 6) { return;}

        _pushView.typeLable.text = @[@"信用标",@"净值标",@"天标",@"担保标",@"抵押标",@"流转标"][buttonIndex];
        _biaoType = @[@"credit",@"worth",@"day",@"vouch",@"pawn",@"roam"][buttonIndex];
        
        
    }
    if (actionSheet == _stateSheet) {
        if (buttonIndex == 5) { return;}

        _pushView.stateLable.text = @[@"投标中",@"已转让",@"回收完",@"回收中",@"已流转"][buttonIndex];
        _biaoState = @[@"tender",@"change",@"end",@"recover",@"over"][buttonIndex];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadMyInvestData];
    
    //隐藏tabbar
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.tabBarVC.tabBar.hidden = YES;
}

-(void)customNavigtionBar
{
    //初始化选择标的时间
    _biaoETime = @"";
    _biaoBTime = @"";
    _biaoState = @"";
    _biaoType = @"";
    _pages = @"10";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.pushView.timePickView.hidden = YES;
    _one = YES;
    
    //2.导航栏的图片
    UIImage *bg = [UIImage imageNamed:@"ht_na_bg"];
    [self.navigationController.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //3.设置statusbar的颜色
    [[HTView shareHTView]setStatusBarBg:self.navigationController];

    
}

-(void)customTypeActionSheet
{
    _typeasheet = [[UIActionSheet alloc]initWithTitle:@"选择标种" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"信用标",@"净值标",@"天标",@"担保标",@"抵押标",@"流转标", nil];
    _typeasheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_typeasheet showInView:self.view];
}

-(void)customStateActionSheet
{
    _stateSheet = [[UIActionSheet alloc]initWithTitle:@"选择状态" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"投标中",@"已转让",@"回收完",@"回收中",@"已流标", nil];
    _stateSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_stateSheet showInView:self.view];
}

//刷新
-(void)refreshTableView:(UITableView *)tavleView
{
    
    //刷新
    tavleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (tavleView == _tableView) {
            
            [HTView isWiffOnView:self.view];
            [self chooseActionData];
            _biaoBTime = @"";
            _biaoETime = @"";
            _biaoState= @"";
            _biaoType = @"";
            _pushView.typeLable.text = @"请选择标种";
            _pushView.startLable.text = @"请选择开始时间";
            _pushView.endLable.text = @"请选择结束时间";
            _pushView.stateLable.text = @"请选择标种的状态";
        }
    }];
    
    //加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [HTView isWiffOnView:self.view];
        _pages = [NSString stringWithFormat:@"%d",[_pages intValue] + 10];
        [self chooseActionData];
    }];
    
    
}

//加载列表数据
-(void)loadMyInvestData
{
    [[Tools  shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"borrow",
                          @"q":@"mobile_get_tender_list",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId],
                          @"epage":_pages,
                          @"page":@"1"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par =@{@"diyou":str,@"sign":md5Str};

    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        NSArray *arr = response[@"list"];

   
//        NSLog(@"%@",response);

        [[Tools shareTools]hidenHud];
        [self.tableView.mj_header endRefreshing];
        if ([response[@"total"] intValue] == _biaoArr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    
        //将字典数组转为模型数组
        _biaoArr = [InverstedBiao mj_objectArrayWithKeyValuesArray:arr];
        
        //添加空白占位图
        if (_biaoArr.count == 0) {
            [_tableView addSubview:self.emptyView];
            [self.tableView reloadData];

        }else{
            [self.emptyView removeFromSuperview];
            [self.tableView reloadData];
        }
        

    } fail:^(NSError *error) {
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];


    }];
}

//加载筛选数据
-(void)chooseActionData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    //筛选数据
    NSDictionary *dic = @{
                          @"module":@"borrow",
                          @"q":@"mobile_get_tender_list",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId],
                          @"dotime1":_biaoBTime,
                          @"dotime2":_biaoETime,
                          @"borrow_type":_biaoType,
                          @"status_type":_biaoState,
                          @"epage":_pages,
                          @"page":@"1"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//               NSLog(@"%@",response);
        
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_header endRefreshing];
        
        if ([response[@"total"] intValue] == _biaoArr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        //将字典数组转为模型数组
        _biaoArr = [InverstedBiao mj_objectArrayWithKeyValuesArray:response[@"list"]];
        
        if (_biaoArr.count == 0) {
            
            [_tableView addSubview:self.emptyView];
            [self.tableView reloadData];

        }else{
            [self.emptyView removeFromSuperview];
            [self.tableView reloadData];

        }
       


    } fail:^(NSError *error) {
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];


}

@end

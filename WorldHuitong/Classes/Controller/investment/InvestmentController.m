//
//  InvestmentController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/20.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//
#define APP_CHANGEVOICE1 @"CJHANGE1"
#define APP_CHANGEVOICE2 @"CJHANGE2"
#define APP_CHANGEVOICE3 @"CJHANGE3"
#define APP_CHANGEVOICE4 @"CJHANGE4"

#define chooseID @"chooseCell"
#import "InvestmentController.h"
#import "TenderCell.h"
#import "CounterController.h"        //计算器
#import "TenderDetailController.h"   //详情标
#import "JYSlideSegmentController.h" //筛选控制器
#import "ChooseCell.h"
#import "Biao.h"
#import "EmptyView.h"

@interface InvestmentController ()

/**投资列表view**/
@property (strong, nonatomic) IBOutlet UIView *AView;

/**按钮的背景**/
@property (weak, nonatomic) IBOutlet UIView *button_bg;

/**投资列表**/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**筛选列表**/
@property(nonatomic,strong) UITableView *table1;
@property(nonatomic,strong)JYSlideSegmentController *slideSegmentController;
@property(nonatomic,strong)UITableViewController *vcc1;
@property(nonatomic,strong)UITableViewController *vcc2;
@property(nonatomic,strong)UITableViewController *vcc3;
@property(nonatomic,strong)UITableViewController *vcc4;
@property(nonatomic,strong)UIButton *queDing;

/**空的图片**/
@property(nonatomic,strong)EmptyView *emptyView;

/**title数组**/
@property(nonatomic,strong)NSArray *typeTitles;
@property(nonatomic,strong)NSArray *moneyTitles;
@property(nonatomic,strong)NSArray *rateTitles;
@property(nonatomic,strong)NSArray *timeTitles;


/***********************************************/
@property(nonatomic,strong)NSArray *typeIds;
@property(nonatomic,strong)NSArray *moneyIds;

/**蒙版按钮**/
@property(nonatomic,strong)UIButton *cancelBtnV;
@property(nonatomic,strong)UIButton *cancelBtnH;

/**分段控制器的选中位置**/
@property(nonatomic,assign)NSInteger segementIndex;

/**中间变量按钮**/
@property(nonatomic,strong)UIButton *tempBtn;
@property(nonatomic,strong)UIButton *touchBtn; //记录按钮多次被点击


/**默认按钮**/
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@property(nonatomic,strong)NSArray *BtnTitles;

@property(assign,nonatomic)BOOL upOrDown;
@property(assign,nonatomic)BOOL upOrDown1;

//模型数组
@property(nonatomic,strong)NSArray *biaoArray;
@property(nonatomic,strong)NSString *order;   //排序条件
@property(nonatomic,assign)int pages;         //页数


@end

@implementation InvestmentController

-(EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 54-64 - 49) Title:@"没有符合条件的标的！" Image:@"touzi"];
    }
    return _emptyView;
}

/**懒加载竖直蒙版按钮**/
-(UIButton *)cancelBtnV
{
    if (!_cancelBtnV) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, 100, kScreenHeigth)];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //5.检测网络
    [HTView isWiffOnView:self.view];
    
    //2.
    [ self customSubView];
    
    //3.
    [self customNavigationTiele];
    
    //4.投资列表的数据
    [self loadInvestListData];
    
    //1.自动刷新
    [self refreshViewTableView:_tableView];
}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if (tableView == self.table1){
        return 8;
    }if (tableView == _vcc1.tableView) {
        return _typeTitles.count;
    }
    if (tableView == _vcc2.tableView) {
        return _moneyTitles.count;
    }
    if (tableView == _vcc3.tableView) {
        return _rateTitles.count;
    }
    if (tableView == _vcc4.tableView) {
        return _timeTitles.count;
    }
    return _biaoArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {

        return [[[TenderCell alloc] init]tenderCell:tableView indexPath:indexPath Modle:_biaoArray[indexPath.row]];
        
    }
    UITableViewCell *cell = [self creatTableViewcell:tableView];
    if (tableView == _vcc1.tableView) {
        
        [self tableViewCell:cell checkmarkAtIndexPath:indexPath WithArr:_typeTitles Key:APP_CHANGEVOICE1];
        
        }
    if (tableView == _vcc2.tableView) {
            [self tableViewCell:cell checkmarkAtIndexPath:indexPath WithArr:_moneyTitles Key:APP_CHANGEVOICE2];
        }
    if (tableView == _vcc3.tableView) {
            [self tableViewCell:cell checkmarkAtIndexPath:indexPath WithArr:_rateTitles Key:APP_CHANGEVOICE3];
        }
    if (tableView == _vcc4.tableView) {
            [self tableViewCell:cell checkmarkAtIndexPath:indexPath WithArr:_timeTitles Key:APP_CHANGEVOICE4];
        }

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return 120;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *indexPaths = [tableView indexPathForSelectedRow];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPaths];
    
    if (tableView == self.tableView)
    {
        TenderDetailController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"TenderDetailController"];     //详情界面
        detail.vcType = @"investment";
        detail.biao = _biaoArray[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }
    
    if (tableView == _vcc1.tableView) //类型
    {
        [self didSelectTableViewCell:cell AtIndexpath:indexPath WithArr:_typeTitles UIViewController:_vcc1 Key:APP_CHANGEVOICE1];
    }
    if (tableView == _vcc2.tableView) { //金额
        [self didSelectTableViewCell:cell AtIndexpath:indexPath WithArr:_moneyTitles UIViewController:_vcc2 Key:APP_CHANGEVOICE2];
    }
    if (tableView == _vcc3.tableView) { //利率
         [self didSelectTableViewCell:cell AtIndexpath:indexPath WithArr:_rateTitles UIViewController:_vcc3 Key:APP_CHANGEVOICE3];
    }
    if (tableView == _vcc4.tableView) { //期限
        [self didSelectTableViewCell:cell AtIndexpath:indexPath WithArr:_timeTitles UIViewController:_vcc4 Key:APP_CHANGEVOICE4];
    }
}

/**投资列表排序方式**/
- (IBAction)choeseAButton:(UIButton *)sender
{
    _touchBtn = sender;
    sender.enabled = NO;
    //1.点击状态的设置
    [self buttonSeleted:sender tag:sender.tag EdgeLeft:50 Rigth:10];

    //2.点击刷新新数据
    if (sender.tag == 1001) {        //默认
        
        //刷新数据->默认
        _pages = 10;
        _order = @"";
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadInvestListData];
        }];
        
        //加载更多-默认
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pages = 10 + _pages;
            [self loadInvestListData];
        }];

    }else if (sender.tag == 1002) {        //金额
        
        //刷新数据->金额
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pages = 10;
            if (_upOrDown == NO)
            {
                _order = @"account_down";
                [self loadInvestListData];
            }else{
                _order = @"account_up";
                [self loadInvestListData];
            }
        }];
        
        //加载更多-金额
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pages = 10 + _pages;
            [self loadInvestListData];
        }];
        
    }else if (sender.tag == 1003){    //利息
        
        //刷新数据->利息
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pages = 10;
            if (_upOrDown == NO)
            {
                _order = @"apr_down";
                [self loadInvestListData];
            }else{
                _order = @"apr_up";
                [self loadInvestListData];
            }
        }];
        
        //加载更多-利息
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pages = 10 + _pages;
            [self loadInvestListData];
        }];
        
    }else if (sender.tag == 1004){    //进度
        
        //刷新数据->进度
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pages = 10;
            if (_upOrDown == NO)
            {
                _order = @"scale_down";
                [self loadInvestListData];
            }else{
                _order = @"scale_up";
                [self loadInvestListData];
            }
        }];
        
        //加载更多-进度
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pages = 10 + _pages;
            [self loadInvestListData];
        }];
        
    }else if (sender.tag == 1005){    //期限
        
        //刷新数据->期限
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pages = 10;
            if (_upOrDown == NO)
            {
                _order = @"period_down";
                [self loadInvestListData];
            }else{
                _order = @"period_up";
                [self loadInvestListData];
            }
        }];
        
        //加载更多-期限
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pages = 10 + _pages;
            [self loadInvestListData];
        }];
            }
    
    [self.tableView.mj_header beginRefreshing];   //马上进入刷新状态
    
}

/**计算器**/
- (IBAction)counter:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    CounterController *counter = [[CounterController alloc]init];
    [self.navigationController pushViewController:counter animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/**筛选**/
- (IBAction)choose:(id)sender
{
    //添加蒙版
     AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app.window addSubview:self.cancelBtnV];
    [app.window addSubview:self.cancelBtnH];
    
    //创建确认按钮
    self.queDing = [[UIButton alloc]initWithFrame:CGRectMake(110, kScreenHeigth - 74, kScreenWidth - 120, 44)];
    [_queDing setTitle:@"确定" forState:UIControlStateNormal];
    [_queDing addTarget:self action:@selector(queDingAction) forControlEvents:UIControlEventTouchUpInside];
    [[HTView shareHTView]setView:_queDing cornerRadius:4];
    _queDing.backgroundColor = HT_COLOR;

    
    //创建四个tableView
    _vcc1 = [self tableViewController:_vcc1 Title:@"类型"];
    _vcc2 = [self tableViewController:_vcc2 Title:@"金额"];
    _vcc3 = [self tableViewController:_vcc3 Title:@"利率"];
    _vcc4 = [self tableViewController:_vcc4 Title:@"期限"];

    NSArray *vcs = @[_vcc1,_vcc2,_vcc3,_vcc4];

    //滑块选择器
    self.slideSegmentController = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    self.slideSegmentController.view.frame = CGRectMake(100, 64, kScreenWidth - 100 , kScreenHeigth - 64);
    [app.window addSubview:self.slideSegmentController.view];
    [app.window addSubview:_queDing];

}

/**移除蒙版**/
-(void)cancelAction
{
    [_cancelBtnV removeFromSuperview];
    [_cancelBtnH removeFromSuperview];
    [_queDing removeFromSuperview];
    [self.slideSegmentController.view removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:APP_CHANGEVOICE1];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:APP_CHANGEVOICE2];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:APP_CHANGEVOICE3];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:APP_CHANGEVOICE4];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


-(void)buttonSeleted:(UIButton *)btn tag:(NSInteger)tag EdgeLeft:(CGFloat)left Rigth:(CGFloat)rigth
{
    //1.image和title的偏移
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, left, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, rigth)];
    
    
   //2.多个选中一个
    if(btn != self.tempBtn){
        self.tempBtn.selected = NO;
        _defaultBtn.selected = NO;
        self.tempBtn = btn;
    }
    self.tempBtn.selected = YES;
    
    if (btn.selected) {
        [btn setTitleColor:HT_COLOR forState:UIControlStateSelected];
    }

    if (btn.tag == 1001) {
        return;
    }
    
    if (_upOrDown == NO){
        [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateSelected];
        _upOrDown = !_upOrDown;
        
    }else if(_upOrDown == YES){
        
        [btn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateSelected];
        _upOrDown = !_upOrDown;
    }
    
}


-(void)refreshViewTableView:(UITableView *)tavleView
{
    //1.刷新
    tavleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (tavleView == _tableView) {
            
            //检测网络
            [HTView isWiffOnView:self.view];
            [self loadInvestListData];
            [[Tools shareTools]hidenHud];
        }
    }];
//    [tavleView.mj_header beginRefreshing];
    
    //2.加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        //检测网络
        [HTView isWiffOnView:self.view];
        _pages = _pages + 10;
        [self loadInvestListData];
        
    }];

}


-(UITableViewController*)tableViewController:(UITableViewController*)tabVC Title:(NSString*)title
{
    tabVC = [[UITableViewController alloc]init];
    tabVC.tableView.tableFooterView = [[UIView alloc]init];
    tabVC.tableView.delegate = self;
    tabVC.tableView.dataSource = self;
    tabVC.title = title;
    return tabVC;
}

-(void)tableViewCell:(UITableViewCell*)cell checkmarkAtIndexPath:(NSIndexPath*)indexPath WithArr:(NSArray *)arr Key:(NSString *)key
{
    cell.textLabel.text = arr[indexPath.row];

    if ([[[NSUserDefaults standardUserDefaults]valueForKey:key] isEqualToString:[arr objectAtIndex:indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

}

-(UITableViewCell*)creatTableViewcell:(UITableView*)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseID ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
        return cell;
}

-(void)didSelectTableViewCell:(UITableViewCell*)cell  AtIndexpath:(NSIndexPath*)indexPath WithArr:(NSArray*)arr UIViewController:(UITableViewController*)tabVC Key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]setValue:[arr objectAtIndex:indexPath.row] forKey:key];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:key] isEqualToString:[arr objectAtIndex:indexPath.row]]){
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tabVC.tableView reloadData];


}


//列表数据
-(void)loadInvestListData
{
    NSString *page = [NSString stringWithFormat:@"%d",_pages];
    NSDictionary *dic = @{
                          @"module":@"borrow",
                          @"q":@"get_list",
                          @"method":@"get",
                          @"showstatus":@"invest",
                          @"page":@"1",
                          @"epage":page,
                          @"order":_order
                          };
    [self loadData:dic];

}

//筛选数据
-(void)loadInvestChooseDataWithMoney:(NSString *)money Type:(NSString *)type Rate:(NSString *)rate Time:(NSString *)time
{
    NSString *page = [NSString stringWithFormat:@"%d",_pages];
    NSDictionary *dic = @{
                          @"module":@"borrow",
                          @"q":@"get_list",
                          @"method":@"get",
                          @"account_status":money,
                          @"spread_month":time,
                          @"borrow_type":type,
                          @"borrow_interestrate":rate,
                          @"showstatus":@"invest",
                          @"page":@"1",
                          @"epage":page,
                          };
    [self loadData:dic];
}


-(void)loadData:(NSDictionary *)dic
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.navigationController.view];
    //检测网络
    [HTView isWiffOnView:self.view];
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    

    [HYBNetworking getWithUrl:kBaseUrl refreshCache:YES params:par success:^(id response) {
//      NSLog(@"%@",response);
        [[Tools shareTools]hidenHud];
        if ([response[@"result"] isEqualToString:@"success"]) {

            if ([response[@"list"] count] == 0) {
                [_tableView addSubview:self.emptyView];
                [self.tableView reloadData];
                
            }else{
                [self.emptyView removeFromSuperview];
                [self.tableView reloadData];
            }
            
        }else{
            
            [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:@"failure" OnView:self.navigationController.view Hide:1];
        }
        
        //将字典数组转为模型数组
        _biaoArray = [Biao mj_objectArrayWithKeyValuesArray:response[@"list"]];
        _touchBtn.enabled = YES;

        [self.tableView.mj_header endRefreshing];
        if ([response[@"total"] intValue] == _biaoArray.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    
}

//按条件筛选标-确定按钮
-(void)queDingAction
{
    
    NSString *type =  [[NSUserDefaults standardUserDefaults]objectForKey:APP_CHANGEVOICE1];
    NSString *money = [[NSUserDefaults standardUserDefaults]objectForKey:APP_CHANGEVOICE2];
    NSString *rate =  [[NSUserDefaults standardUserDefaults]objectForKey:APP_CHANGEVOICE3];
    NSString *time =  [[NSUserDefaults standardUserDefaults]objectForKey:APP_CHANGEVOICE4];

    //类型
    if ([type isEqualToString:@"信用标"]) {
        type = @"credit";
    }else if ([type isEqualToString:@"担保标"]){
        type = @"vouch";
    
    }else if ([type isEqualToString:@"天标"]){
        type = @"day";
        
    }else if ([type isEqualToString:@"抵押标"]){
        type = @"pawn";
        
    }else if ([type isEqualToString:@"流转标"]){
        type = @"roam";
        
    }else if ([type isEqualToString:@"净值标"]){
        type = @"worth";
    }else{
        type = @"";
    }
    

    //金额
    if ([money isEqualToString:@"10万以下"]) {
        money = @"11";
    }else if ([money isEqualToString:@"10万-50万"]){
        money = @"12";
        
    }else if ([money isEqualToString:@"50万-100万"]){
        money = @"8";
        
    }else if ([money isEqualToString:@"100万以上"]){
        money = @"13";
        
    }else {
        money = @"";
    }

    //利率
    if ([rate isEqualToString:@"0%-5%"]) {
        rate = @"11";
    }else if ([rate isEqualToString:@"5%-10%"]){
        rate = @"12";
        
    }else if ([rate isEqualToString:@"10%-15%"]){
        rate = @"8";
        
    }else if ([rate isEqualToString:@"15%-20%"]){
        rate = @"13";
        
    }else if ([rate isEqualToString:@"20%-24%"]){
        rate = @"8";
        
    }else if ([rate isEqualToString:@"24%以上"]){
        rate = @"13";
        
    }else {
        rate = @"";
    }
    
    //期限
    if ([time isEqualToString:@"一月标"]) {
        time = @"1";
    }else if ([time isEqualToString:@"二月标"]){
        time = @"2";
        
    }else if ([time isEqualToString:@"三月标"]){
        time = @"3";
        
    }else if ([time isEqualToString:@"其他（四月份和六月标）"]){
        time = @"4";
        
    }else {
        time = @"";
        
    }
    _pages = 10;

    //请求筛选的数据
        //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //检测网络
        [HTView isWiffOnView:self.view];
        [self loadInvestChooseDataWithMoney:money Type:type Rate:rate Time:time];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //检测网络
    [HTView isWiffOnView:self.view];
    
    //加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pages = _pages + 10;
        [self loadInvestChooseDataWithMoney:money Type:type Rate:rate Time:time];
    
    }];
    
    //移除蒙版
    [self cancelAction];
    
}

-(void)customSubView
{
    _pages = 10;
    _order = @"";
    self.view.backgroundColor = HT_BG_COLOR;
    
    //1.顶部按钮
    [[HTView shareHTView]setView:_button_bg cornerRadius:4];
    _defaultBtn.selected = YES;
    _upOrDown = NO;
    [_defaultBtn setTitleColor:HT_COLOR forState:UIControlStateSelected];
    
    //2.导航栏的图片
    [HTView navigationBarBgImage:self.navigationController Image:kNa_bg_image];
    [[HTView shareHTView]setStatusBarBg:self.navigationController];
    self.navigationItem.title = @"";
    

    /**1.投资列表view**/
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    
    /**3.筛选view**/
    _typeTitles = @[@"信用标",@"担保标",@"抵押标",@"净值标",@"流转标",@"天标"];
    _BtnTitles = @[@"类型",@"金额",@"利率",@"期限"];
    _typeIds = @[@"credit",@"vouch",@"pawn",@"worth",@"roam",@"day"];
    _moneyTitles = @[@"10万以下",@"10万-50万",@"50万-100万",@"100万以上"];
    _moneyIds = @[@"11",@"12",@"8",@"13"];
    _rateTitles = @[@"0%-5%",@"5%-10%",@"10%-15%",@"15%-20%",@"20%-24%",@"24%以上"];
    _timeTitles =  @[@"一月标",@"二月标",@"三月标",@"其他（四月标和 六月标）"];
    
    
}

-(void)customNavigationTiele
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLable.text = @"投资列表";
    titleLable.font = [UIFont boldSystemFontOfSize:17.0];
    titleLable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleLable;
}


@end

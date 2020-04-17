//
//  MyRecommendController.m
//  WorldHuitong
//
//  Created by TXHT on 16/6/6.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "MyRecommendController.h"
#import "MyRecommendCell.h"
#import "MyRecommend.h"
#import "NSString+Category.h"
#import "EmptyView.h"

@interface MyRecommendController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *myRecommends;
@property(nonatomic,strong)NSString *pages;

/**空的图片**/
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation MyRecommendController

-(EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 74) Title:@"还没有我推荐的好友" Image:@"touzi"];
    }
    return _emptyView;
}


- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.view];

    [self creatTableView];
    
    //刷新加载
    [self refreshAndReload];
    
    
}

-(void)refreshAndReload
{
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadMyRecommendData];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        _pages = [NSString stringWithFormat:@"%d",[_pages intValue] + 10];
        [self loadMyRecommendData];
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myRecommends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyRecommendCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MyRecommendCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyRecommend *myRecommend = _myRecommends[indexPath.row];
    
    cell.myfriend.text = [NSString stringWithFormat:@"%@",myRecommend.username];
    cell.istouzi.text = myRecommend.status_name;

    if ([myRecommend.status_name isEqualToString:@"未达标"]) {
        cell.jiangli.text = @"未发奖励";
        cell.jiangli.font = [UIFont systemFontOfSize:16];
        cell.jiangli.textColor = [UIColor lightGrayColor];
    }else{
        cell.istouzi.textColor = [UIColor redColor];
        cell.jiangli.text = myRecommend.remark;
    }
  

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)loadMyRecommendData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"spreads",
                          @"q":@"get_log_list",
                          @"method":@"get",
                          @"spreads_userid":[Tools HtUserId],
                          @"page":@"1",
                          @"epage":_pages
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//      NSLog(@"%@",response);
        
        //结束加载
        if ([response[@"total"] intValue] == _myRecommends.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
        [[Tools shareTools]hidenHud];
    
        //字典转模型
        _myRecommends = [MyRecommend mj_objectArrayWithKeyValuesArray:response[@"list"]];
        
        //添加空白占位图
        if (_myRecommends.count == 0) {
            [_tableView addSubview:self.emptyView];
            [self.tableView reloadData];
        }else{
            [self.emptyView removeFromSuperview];
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];

}

-(void)creatTableView
{
    self.view.backgroundColor = HT_BG_COLOR;
    self.navigationItem.title = @"我的推荐";
    _pages = @"10";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.tabBarVC.tabBar.hidden = YES;
    
}

@end

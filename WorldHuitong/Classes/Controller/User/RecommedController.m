//
//  RecommedController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RecommedController.h"
#import "RecommendView.h"
#import "RecommendRulesController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "MyRecommendController.h"
#import "GTMBase64.h"
@interface RecommedController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**推荐规则**/
@property (weak, nonatomic) IBOutlet UIButton *recommendRule;

/**我的推荐**/
@property (weak, nonatomic) IBOutlet UIButton *myRecommend;
@property(nonatomic,strong)NSString *urlstr;

@end

@implementation RecommedController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    NSString *ID = [GTMBase64 encodeBase64String:[[Tools HtUserId] stringValue]];
    NSString *utfID = [Tools utf8:ID];
    
    //推荐的网址
    _urlstr = [NSString stringWithFormat:@"%@/api/recommend/index.php?user=%@",kBaseImageUrl,utfID];
    
    //
    [_recommendRule setTitleColor:HT_COLOR forState:UIControlStateNormal];
    [_myRecommend setTitleColor:HT_COLOR forState:UIControlStateNormal];
    //
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.showsVerticalScrollIndicator = NO;
   //
    self.navigationItem.title = @"推荐好友一起拿红包";
    self.view.backgroundColor = HT_BG_COLOR;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return 0;}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     return [RecommendView headViewWithController:self Url:_urlstr];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenHeigth - 64;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
}


//推荐规则
- (IBAction)ruleAction:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    RecommendRulesController *rules = [[RecommendRulesController alloc]init];
    [self.navigationController pushViewController:rules animated:YES];
    
}

//我的推荐
- (IBAction)myRecommed:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    [self  performSegueWithIdentifier:@"MyRecommendController" sender:nil];
}


//我要推荐
-(void)recommendAction
{
    
    NSString *contentUrl = [NSString stringWithFormat:@"正在用国内最安全的理财app，注册送您红包哦%@",_urlstr];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentUrl
                                       defaultContent:contentUrl
                                                image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"regist"]]
                                                title:@"注册送红包哦!"
                                                  url:_urlstr
                                           description:@"加送888元理财金"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制短信信息
    [publishContent addCopyUnitWithContent:_urlstr image:nil];
    
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

//
//  NewBiaoBuyController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/17.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "NewBiaoBuyController.h"
#import "NewBiaoBuyCell.h"
#import "RegShuangQianViewController.h"
#import "GTMBase64.h"
@interface NewBiaoBuyController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *querenBtn;
@property(nonatomic,strong)NSString *nowDateStr;            //当前时间
@property(nonatomic,strong)NSString *sevenLater;            //七天后的时间
@property(nonatomic,strong)NSString *amount;                //体验经

@end

@implementation NewBiaoBuyController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatTableView];
    
    [self lixiDate];
    

    
}


#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 1;}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"NewBiaoBuyCell";
    NewBiaoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NewBiaoBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.lixiStard.text = [NSString stringWithFormat:@"生息时间：%@",_nowDateStr];
    cell.lixiEnd.text = [NSString stringWithFormat:@"结息时间：%@",_sevenLater];
    cell.acoument.text = @"888元";
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:3];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215;
}

- (IBAction)qurenAction:(id)sender
{

    if (![Tools isConnectionAvailable]) { //没有网络链接
        
        [HTView isWiffOnView:self.view];
    }else{         //有网络链接
    
        if (![Tools HtUserId]) {     //没登陆
            
        }else{                       //登陆
            [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
            NSDictionary*diccc = @{
                                   @"user_id":[Tools HtUserId],
                                   @"method":@"post",
                                   @"module":@"trust",
                                   @"q":@"tender_roam",
                                   @"borrow_nid":_borrow_nid,
                                   @"tender_account":@"888"
                                   };
            
            NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
            NSString *strHT = [[Tools shareTools]htstr:str];
            NSString *md5Par = [[Tools shareTools] md5:strHT];
            NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
            
            [HYBNetworking getWithUrl:kBaseUrl refreshCache:YES params:par success:^(id response) {
                [[Tools shareTools]hidenHud];
                
//              NSLog(@"%@",response);
                
                if ([response[@"result"] isEqualToString:@"error"]) {
                    [HTView alterTitle:response[@"error_remark"]];
               
                }else{
                    RegShuangQianViewController *shangqianVC = [[RegShuangQianViewController alloc]init];
                    
                    NSString *url = response[@"data"][@"url"];
                    NSString *baseUrl = [GTMBase64 decodeBase64String:url];
                    NSString *utf8Url = [baseUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    shangqianVC.url = utf8Url;
                    
                    shangqianVC.alterTitle = @"恭喜您,认购成功!";
                    [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"buyNewBiao"];
                    [self.navigationController pushViewController:shangqianVC animated:YES];
                    
                }
                
            } fail:^(NSError *error) {
                [[Tools shareTools]hidenHud];
                
            }];
            
        }
    }
    

}

-(void)creatTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = HT_BG_COLOR;
    _querenBtn.backgroundColor = HT_COLOR;
    self.title = @"认购";

}


-(void)lixiDate
{
    NSInteger dis = 7; //天数
    NSDate*nowDate = [NSDate date];
    NSString *nowStr = [NSString stringWithFormat:@"%@",nowDate];
    _nowDateStr = [nowStr substringToIndex:10];
    
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDate *theDate = [nowDate initWithTimeIntervalSinceNow: + oneDay*dis ];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",theDate];
    _sevenLater = [dataStr substringToIndex:10];

}




@end

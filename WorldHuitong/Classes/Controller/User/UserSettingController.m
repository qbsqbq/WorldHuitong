//
//  UserSettingController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/28.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "UserSettingController.h"
#import "UserSettingCell.h"
#import "RealNameController.h"       //实名认证
#import "ModifyLogPwController.h"    //修改登陆密码
#import "clearPwController.h"        //解锁密码
#import "TradersPwController.h"      //交易密码
#import "ShuangQianController.h"     //双乾认证
#import "PhoneController.h"          //手机认证
#import "AuthorizeAgainController.h" //二次授权
#import "BankCardController.h"       //银行卡认证
#import "BankCardMangerController.h" //管理银行卡
#import "PhoneResultController.h"    //手机认证结果
#import "RealNameResultController.h" //实名认证结果
#import "SucessViewController.h"     //注册成功
#import "HomeController.h"
#import "LogController.h"
#import "SDWebImageManager.h"
#import "GTMBase64.h"

@interface UserSettingController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSString *openAccount; //是否开户
@property(nonatomic,strong)NSString *secondOffer; //是否二次授权
@property(nonatomic,strong)UIAlertView *alterLogOut;
@property(nonatomic,strong)UIAlertView *alter;


@end

@implementation UserSettingController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self creatTableView];

    //刷新
    [self refreshView:self.tableView];
    
    
}

#pragma ----UITableViewDataSource----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ return 3;}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }if (section == 1) {
        return 3;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [UserSettingCell UserSettingCellWithTableView:tableView IndexPath:indexPath Modle:_user OpenAccount:_openAccount SecondOffer:_secondOffer];

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"身份",@"安全",@"通用"][section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 130;
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [[UIView alloc]init];
        UIButton *Logout = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth - 20, 44)];
        [Logout setTitle:@"退出登录" forState:UIControlStateNormal];
        [Logout setBackgroundImage:[UIImage imageNamed:@"ht_na_bg"] forState:UIControlStateNormal];
        [Logout setBackgroundImage:[UIImage imageNamed:@"ht_btn_highligthed"] forState:UIControlStateHighlighted];
        [Logout setBackgroundColor:HT_COLOR];
        [Logout addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
        [[HTView shareHTView]setView:Logout cornerRadius:4];
        [view addSubview:Logout];
        return view;
        
    }
    return nil;

}

#pragma ----UITableViewDelegate----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {                                                   //手机认证
            if ([_user.phone_status  isEqualToString:@"1"]) {
               
                self.hidesBottomBarWhenPushed = YES;
                PhoneResultController *phoneResult = [[PhoneResultController alloc]init];
                [self.navigationController pushViewController:phoneResult animated:YES];
                phoneResult.phoneNumber = _user.phone;
            }else{
                PhoneController *phone = [[PhoneController alloc]init];
                [self.navigationController pushViewController:phone animated:YES];
            }
        }
        if (indexPath.row == 1) {                                                   //实名认证
            
            if ([_user.realname_status  isEqual: @"-1"]) {          //未认证
               
                self.hidesBottomBarWhenPushed = YES;
                RealNameController *realName = [[RealNameController alloc]init];
                realName.userName = _user.username;
                [self.navigationController pushViewController:realName animated:YES];
            }else if([_user.realname_status intValue] >= 0){       //审核中 // 已认证
                
                self.hidesBottomBarWhenPushed = YES;
                RealNameResultController *realNameResult = [[RealNameResultController alloc]init];
                realNameResult.realNameState = _user.realname_status;
                realNameResult.personID = _personID;
                realNameResult.realName = _realName;
                [self.navigationController pushViewController:realNameResult animated:YES];
            
            }
        }
        if (indexPath.row == 2) {                                                  //双乾托管认证
            self.hidesBottomBarWhenPushed = YES;
            ShuangQianController *shaungQian= [[ShuangQianController alloc]init];
            shaungQian.open = _openAccount;
            [self.navigationController pushViewController:shaungQian animated:YES];
        }
        if (indexPath.row == 3) {                                                  //二次授权
            if (![_openAccount isEqualToString:@"error"]) {
               
                [self authorizeAgain];
            }else{
               
                [HTView alterTitle:@"您还没有开通双乾托管！"];
            }
        }
        if (indexPath.row == 4) {                                                  //注册成功
            if (![_openAccount isEqualToString:@"error"] && ![_secondOffer isEqualToString:@"error"]){
                self.hidesBottomBarWhenPushed = YES;
                SucessViewController *regSuss = [[SucessViewController alloc]init];
                [self.navigationController pushViewController:regSuss animated:YES];
            }
        }
        if (indexPath.row == 5) {                                                  //银行卡认证
            if ([_user.realname_status  isEqual: @"1"]) {
           
                if ([_user.bank_status isEqualToString:@"0"]) { //没认证过
                    self.hidesBottomBarWhenPushed = YES;
                    BankCardController *bankCard = [[BankCardController alloc]init];
                    bankCard.realName = _realName;
                    [self.navigationController pushViewController:bankCard animated:YES];
                }else if([_user.bank_status isEqualToString:@"1"]){            //认证过
                    
                    self.hidesBottomBarWhenPushed = YES;
                    BankCardMangerController *modifyBcVC = [[BankCardMangerController alloc]init];
                    modifyBcVC.realName = _realName;
                    [self.navigationController pushViewController:modifyBcVC animated:YES];
                }
            
            }else{

               [HTView alterTitle:@"请先完成实名认证"];
            }
            
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {                                                  //登陆密码
            self.hidesBottomBarWhenPushed = YES;
            ModifyLogPwController *logTab = [[ModifyLogPwController alloc]init];
            [self.navigationController pushViewController:logTab animated:YES];
        }
        if (indexPath.row == 1) {                                                   //解锁密码
            self.hidesBottomBarWhenPushed = YES;
            clearPwController *clearTab = [[clearPwController alloc]init];
            [self.navigationController pushViewController:clearTab animated:YES];
        }
        if (indexPath.row == 2) {                                                   //交易密码
            self.hidesBottomBarWhenPushed = YES;
            TradersPwController *traderTab = [[TradersPwController alloc]init];
            [self.navigationController pushViewController:traderTab animated:YES];

        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {       //清除缓存

            _alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清除缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_alter show];
        }
    }

}

#pragma *************************请求数据**********************************
-(void)refreshView:(UITableView *)collectionView
{
    //1.自动刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadShuangQianData];
        [self loadMemberData];
    }];
}

-(void)loadShuangQianData
{
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    NSDictionary *dic = @{
                          @"module":@"trust",
                          @"q":@"get_trust",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId]
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:YES params:par success:^(id response) {

//           NSLog(@"%@",response);
        [self.tableView.mj_header endRefreshing];
        _openAccount = response[@"approve_result"][@"reg_trust"];
        _secondOffer = response[@"approve_result"][@"trust"];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

-(void)loadMemberData
{
    NSDictionary *dic = @{@"module":@"users",
                          @"q":@"mobile_get_user_result",
                          @"method":@"get",
                          @"user_id":[Tools HtUserId],
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//      NSLog(@"%@",response);
        
        [self.tableView.mj_header endRefreshing];
        if ([response[@"result"] isEqualToString:@"success"]) {
            
        }else{
            
            [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:@"failure" OnView:self.navigationController.view Hide:2];
        }
        
        //mj的字典转模型
        _user = [User mj_objectWithKeyValues:response];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    //加载双乾开户/授权状态
    [self loadShuangQianData];
    
    //加载会员数据
    [self loadMemberData];

}

-(void)creatTableView
{
    self.navigationItem.title = @"";
  
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
    usernameLabel.text = @"个人中心";
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:17];
    self.navigationItem.titleView = usernameLabel;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.backgroundColor = HT_BG_COLOR;
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _alter) {
  
        if (buttonIndex == 1) {
            
            //清除缓存
            [[SDImageCache sharedImageCache] clearDisk];
            [self.tableView reloadData];
            [[Tools shareTools]progressWithTitle:@"清除成功！" Image:kTimage OnView:self.navigationController.view Hide:1];
        }
    }if (alertView == _alterLogOut) {
        if (buttonIndex == 1) {
            
            //登出-删除user_id
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"lock"]; //关闭指纹
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"OntouchId"];      //关闭手势
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popToRootViewControllerAnimated:NO];
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            app.tabBarVC.selectedIndex = 0;
            
        }
    }

}



//二次授权
-(void)authorizeAgain
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSString *inforStr = [[Tools shareTools]dictionaryToJson:@{@"client_type":@"IOS"}];
    NSString *infor = [GTMBase64 encodeBase64String:inforStr];
    NSDictionary *dic = @{
                          @"module":@"trust",
                          @"q":@"authorize",
                          @"method":@"post",
                          @"user_id":[Tools HtUserId],
                          @"info":infor
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//     NSLog(@"%@",response);
        
        [[Tools shareTools]hidenHud];
        if ([response[@"result"] isEqualToString:@"success"]) {
            if ([_secondOffer isEqualToString:@"error"]) {
     
                AuthorizeAgainController *authorize = [[AuthorizeAgainController alloc]init];
                
                NSString *url = response[@"data"][@"url"];
                NSString *baseUrl = [GTMBase64 decodeBase64String:url];
                NSString *utf8Url = [baseUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                authorize.url = utf8Url;
                
                [self.navigationController pushViewController:authorize animated:YES];
            
            }else {
             
                [[Tools shareTools]progressWithTitle:@"授权已成功！" Image:kTimage OnView:self.view Hide:1];
            }
            
        }else {
        
            [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:kFimage OnView:self.navigationController.view Hide:1];
        }
    
    } fail:^(NSError *error) {
        [[Tools shareTools]hidenHud];

    }];
}

//登出
-(void)logOutAction
{
   _alterLogOut = [[UIAlertView alloc]initWithTitle:nil message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alterLogOut show];
}





@end

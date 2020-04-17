//
//  UserController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#define kheadId @"UseHeadCell"
#define kmarkId @"userMark"

#import "UserController.h"
#import "UseHeadCell.h"
#import "UserMarkCell.h"
#import "UserSettingController.h"   //用户设置
#import "RecommedController.h"      //我的推荐
#import "MyInvestController.h"      //我的投资
#import "RechargeController.h"      //充值
#import "WithdrawController.h"      //体现
#import "CompanyProfileController.h"//公司介绍
#import "MyBillViewController.h"    //我的账单
#import "MyIntegralController.h"    //我的积分
#import "PhoneController.h"         //绑定手机号
#import "LogController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "User.h"

@interface UserController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,retain)NSArray *markTitles;
@property(nonatomic,retain)NSArray *markImages;
@property(nonatomic,strong)UIAlertView *usrAlter;
@property(nonatomic,strong)UIAlertView *wxAlter;
@property(nonatomic,strong)UIAlertView *logAlter;
@property(nonatomic,strong)User *user;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *recover_yes_interest;//累计获取收益
@property(nonatomic,strong)NSString *realname;            //用户的真实名字
@property(nonatomic,strong)NSString *card_id;             //身份证号码（部分）
@property(nonatomic,strong)NSString *avatar_url;          //用户头像
@property(nonatomic,strong)NSString *vip_status;          //是否vip用户


@property(nonatomic,strong)UILabel *naviTitle;


@end

@implementation UserController

-(UILabel *)naviTitle
{
    if (!_naviTitle) {
        _naviTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _naviTitle.textAlignment = NSTextAlignmentCenter;
        _naviTitle.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:19];
        self.navigationItem.titleView = _naviTitle;
    }
    return _naviTitle;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.view];
    
    [self creatCollectionView];
    
    [self refreshData];
    
}

/**
 *  加载个人中心的数据
 */

-(void)refreshData
{
    //第一次加载->没登陆时提示登陆
    if (!kUSER_ID) {
        _logAlter = [[UIAlertView alloc]initWithTitle:nil message:@"请登陆您的账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [_logAlter show];
    }else{
        
    }
    
    //app第一次启动时不用提醒
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
    }else {
       
        //刷新
        [self refreshView:self.collectionView];
        
    }
    
}

/**
 *  刷新collectionView
 */
-(void)refreshView:(UICollectionView *)collectionView
{
    
    //刷新
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        //检测网络
        if ([Tools isConnectionAvailable]) {   //有网
            [self loadUserData];
            
            if (!kUSER_ID) {    //没登陆
                _logAlter = [[UIAlertView alloc]initWithTitle:nil message:@"请登陆您的账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [_logAlter show];
            }else{              //登陆
            }

        }else{                                  //无网
         
            [HTView isWiffOnView:self.view];
            [self.collectionView.mj_header endRefreshing];

        }
        
      
        
    }];
    
    
}


#pragma ----UICollectionViewDataSource----

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {return 1;}
    return self.markTitles.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return [UseHeadCell UseHeadCellWithCollectionView:collectionView ID:kheadId IndexPath:indexPath Modle:_user Interest:_recover_yes_interest];

    }
    
    return [UserMarkCell UserMarkCellCollectionView:collectionView Identifier:kmarkId IndexPath:indexPath Titles:self.markTitles Icons:self.markImages];
}


#pragma ----UICollectionViewDelegate-----

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ) {
        if (indexPath.row == 0) {      //个人中心
//            if (!_user) {
//
//            }else{
            
                if (![Tools isConnectionAvailable]) {
                    [HTView isWiffOnView:self.view];
                }else {
//                    if (kUSER_ID) {
                        self.hidesBottomBarWhenPushed = YES;
                        [self performSegueWithIdentifier:@"UserSettingController" sender:self];
                        self.hidesBottomBarWhenPushed = NO;

//                    }else{
//                        [self presentViewController:[[LogController alloc]init] animated:YES completion:nil];
//                    }
                }
//            }
        }
        if (indexPath.row == 1) {      //我的投资
            if ([Tools isConnectionAvailable]) {
                
                if (!_user) {
                    
                }else{
                    
                    if (kUSER_ID) {
                        [self performSegueWithIdentifier:@"MyInvestController" sender:self];
                    }else{
                        [self presentViewController:[[LogController alloc]init] animated:YES completion:nil];
                    }
                }
            }else{
                [HTView isWiffOnView:self.view];
            }

        }
        if (indexPath.row == 2) {     //积分商城
            
//            if (!_user) {
//            }else{
//                if (kUSER_ID) {
                    self.hidesBottomBarWhenPushed = YES;
                    MyIntegralController *integralVC = [[MyIntegralController alloc]init];

                    [self.navigationController pushViewController:integralVC animated:YES];
                    self.hidesBottomBarWhenPushed = NO;

//                }else{
//                    [self presentViewController:[[LogController alloc]init] animated:YES completion:nil];
//                }
//            }
        }
        if (indexPath.row == 3) {     //我要充值
           
            if (kUSER_ID) {
                
                self.hidesBottomBarWhenPushed = YES;
                RechargeController *recharge = [self.storyboard instantiateViewControllerWithIdentifier:@"RechargeController"];
                [self.navigationController pushViewController:recharge animated:YES];
                self.hidesBottomBarWhenPushed = NO;

            }else{
                
                [self presentViewController:[[LogController alloc]init] animated:YES completion:nil];
            }
            
        }
        if (indexPath.row == 4) {     //我的账单
           
            if (kUSER_ID) {
               
                self.hidesBottomBarWhenPushed = YES;
                MyBillViewController *billVC= [[MyBillViewController alloc]init];
                [self.navigationController pushViewController:billVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;

            }else{
                
                [self presentViewController:[[LogController alloc]init] animated:YES completion:nil];
            }
        }
        if (indexPath.row == 5) {     //我要提现
           
            if (kUSER_ID) {
                
                self.hidesBottomBarWhenPushed = YES;
                WithdrawController *withdraw = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawController"];
                [self.navigationController pushViewController:withdraw animated:YES];
                self.hidesBottomBarWhenPushed = NO;

            }else{
                [self presentViewController:[[LogController alloc]init] animated:YES completion:nil];
            }
            
        }
        if ( indexPath.row == 6)      //关注微信号
        {
            [self alterShow];
        }
        if (indexPath.row == 7) {     //公司简介

                self.hidesBottomBarWhenPushed = YES;
                CompanyProfileController *compFile = [[CompanyProfileController alloc]init];
                [self.navigationController pushViewController:compFile animated:YES];
                self.hidesBottomBarWhenPushed = NO;
        }
        if (indexPath.row == 8) {     //我的推荐
            
            if (kUSER_ID) {
                
                self.hidesBottomBarWhenPushed = YES;
                [self performSegueWithIdentifier:@"RecommedController" sender:self];
                self.hidesBottomBarWhenPushed = NO;

            }else{
             
                [self presentViewController:[[LogController alloc]init] animated:YES completion:nil];
            }
        }
        
    }
}

//传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserSettingController"])
    {
        UserSettingController *setingVC = segue.destinationViewController;
        setingVC.realName = _realname;
        setingVC.personID = _card_id;

    }
}

#pragma ----UICollectionViewDelegateFlowLayout----

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {return CGSizeMake(kScreenWidth, 195);}
    
    float W = kScreenWidth / 3;
    float H = W * 4 / 5;
    return CGSizeMake(W,H);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{return 0;}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{return UIEdgeInsetsMake(0, 0, 0, 0);}


#pragma ----UIAlertViewDelegate-----
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _usrAlter) {
        if (buttonIndex == 1) {
            if ([WXApi isWXAppInstalled]) {
                
                [WXApi openWXApp];
            }else{
                _wxAlter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有安装微信,请到appStore下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [_wxAlter show];
            }
        }
    }

    if (alertView == _wxAlter) {
        if (buttonIndex == 1) {
           
            NSString *str =  [WXApi getWXAppInstallUrl];
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
    
    if (alertView == _logAlter) {
        if (buttonIndex == 1) {
            LogController *logVC = [[LogController alloc]init];
            [self presentViewController:logVC animated:YES completion:nil];
           
        }

        
    }

}



/**
 *  个人中心数据
 */
-(void)loadUserData
{
    NSDictionary *dic = nil;
    if (!kUSER_ID) {
        self.naviTitle.text = @"请登陆账号...";
        dic = @{
                @"module":@"dyp2p",
                @"q":@"get_users",
                @"method":@"get",
                @"user_id":@"00",
               };
    }else {
        self.naviTitle.text = _userName;
        dic = @{
                @"module":@"dyp2p",
                @"q":@"get_users",
                @"method":@"get",
                @"user_id":[Tools HtUserId],
               };
    }
        NSString *str = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:str];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//          NSLog(@"%@",response);
            
            [self.collectionView.mj_header endRefreshing];
            
            if ([response[@"result"] isEqualToString:@"success"]) {
                
                [[NSUserDefaults standardUserDefaults]setValue:response[@"approve_result"][@"phone"]forKey:@"user_phoneNumber"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                _realname = response[@"approve_result"][@"realname"];
                _card_id = response[@"approve_result"][@"_card_id"];
            
                if (![response[@"user_result"]  isEqual: @"0sers_not_exiest"]) {
                    _userName = response[@"user_result"][@"username"];
                    
                        _avatar_url = response[@"user_result"][@"avatar_url"];
                        [[NSUserDefaults
                          standardUserDefaults]setValue:response[@"user_result"][@"avatar_url"] forKey:@"avatar_url"];
                        
                        NSLog(@"_avatar_url===%@",_avatar_url);
                    _vip_status = response[@"user_result"][@"vip_status"];
                    
                    //存本地
                    [[NSUserDefaults standardUserDefaults]setValue:response[@"user_result"][@"username"] forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults]setValue:response[@"user_result"][@"vip_status"] forKey:@"vip_status"];
                    self.naviTitle.text =_userName;
                }
                
            }else{
                
                [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:@"failure" OnView:self.navigationController.view Hide:2];
            }
         
            //mj字典转模型
            _user = [User mj_objectWithKeyValues:response[@"account_result"]];
            _recover_yes_interest = response[@"recover_yes_interest"];
            [self.collectionView reloadData];

        
    } fail:^(NSError *error) {
       
        [self.collectionView.mj_header endRefreshing];
    }];
    
    
}

/**
 * 关注微信号
 */
-(void)alterShow
{
    _usrAlter = [[UIAlertView alloc]initWithTitle:nil                             //关注微信
                                          message:@"您可在微信-通讯录-添加朋友-查找公众账号中搜索@“天下汇通”，点击关注，可更方便的获取我们的最新信息"
                                         delegate:self
                                cancelButtonTitle:@"取消"
                                otherButtonTitles:@"去关注", nil];
    [_usrAlter show];

}

/**
 * 实现通知方法，跳转至绑定手机号
 */
-(void)pushToPhoneVC:(NSNotification*)notic
{
    PhoneController *phoneVC = [[PhoneController alloc]init];
    [self.navigationController pushViewController:phoneVC animated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

      [self loadUserData];

}

-(void)creatCollectionView
{
    self.navigationItem.title = @"";
    self.naviTitle.text = @"请登陆账号...";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.view.backgroundColor = HT_BG_COLOR;
    self.markTitles = @[@"个人中心",@"我的投资",@"我的积分",@"我要充值",@"我的账单",@"我要提现",@"关注微信号",@"公司介绍",@"我的推荐"];
    self.markImages = @[@"icon_account_press",@"icon_account_touzi",@"icon_account_jifen",@"icon_account_chongzhi",@"icon_account_zhangdan",@"icon_account_tixian",@"icon_account_weiXi",@"companlay_icon",@"icon_account_tuijian"];
    
    //2.导航栏的图片
    [HTView navigationBarBgImage:self.navigationController Image:kNa_bg_image];
    [[HTView shareHTView]setStatusBarBg:self.navigationController];
    
    //接受通知，跳转到绑定手机号界面
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(pushToPhoneVC:) name:@"showPhoneController" object:nil];
    
    
}



@end

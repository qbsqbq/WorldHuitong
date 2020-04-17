//
//  NewWelfareController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/17.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "NewWelfareController.h"
#import "NewBiaotiyanCell.h"
#import "NewBiaoWelfareCell.h"
#import "RegisterController.h"
#import "NewBiaoDetaileController.h" //新标的详情
#import "RecommedController.h"       //推荐
@interface NewWelfareController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)AppDelegate *app;
@end

@implementation NewWelfareController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self customSubView];

}


#pragma ----UITableViewDataSource----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NewBiaotiyanCell *cell = [NewBiaotiyanCell newBiaotiyancellWith:tableView];
        [cell.lijiBuy addTarget:self action:@selector(lijiBuyAction) forControlEvents:UIControlEventTouchUpInside];
        NSString *reta = [_xinBiao.borrow_apr stringByAppendingString:@"%"];
        cell.biao_reta.attributedText = [[HTView shareHTView]setLableAttriText:reta];
        cell.biaoName.text = _xinBiao.name;
        
        
        return cell;
    }
    
    NewBiaoWelfareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"footCell"];

    [cell.goRegist addTarget:self action:@selector(goRegistAction) forControlEvents:UIControlEventTouchUpInside];

    [cell.goTouzi addTarget:self action:@selector(goTouziAction) forControlEvents:UIControlEventTouchUpInside];

    [cell.goInvitation addTarget:self action:@selector(goInvitationAction) forControlEvents:UIControlEventTouchUpInside];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        imageView.image = [UIImage imageNamed:@"new_biao_detaile"];
        return imageView;
    }
    return nil;
    
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 250;
    }
    return 130;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    return kScreenWidth / 2;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden = NO;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//立即抢购
-(void)lijiBuyAction
{
    self.hidesBottomBarWhenPushed = YES;
     NewBiaoDetaileController *nbd = [self.storyboard instantiateViewControllerWithIdentifier:@"NewBiaoDetaileController"];
    nbd.xinBiao = _xinBiao;
    [self.navigationController pushViewController:nbd animated:YES];
}

//去注册
-(void)goRegistAction
{
    RegisterController *regestVC = [[RegisterController alloc]init];
    [self presentViewController:regestVC animated:YES completion:nil];
}

//去投资
-(void)goTouziAction
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.app = (AppDelegate*)[[UIApplication sharedApplication]delegate] ;
    self.app.tabBarVC.selectedIndex = 1;
}

//去邀请
-(void)goInvitationAction
{
    if (kUSER_ID) {
        self.hidesBottomBarWhenPushed = YES;
        RecommedController *recommed = [self.storyboard instantiateViewControllerWithIdentifier:@"RecommedController"];
        recommed.xinBiao = YES;
        [self.navigationController pushViewController:recommed animated:YES];
    }else{
        LogController *log = [[LogController alloc]init];
        [self presentViewController:log animated:YES completion:nil];
    
    }

}


 -(void)customSubView
{
    self.navigationItem.title = @"";
    //添加返回按钮
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 44)];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImage:[UIImage imageNamed:@"na_back"] forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.view.backgroundColor = HT_BG_COLOR;
    
}




@end

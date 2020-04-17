//
//  LogController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/7.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "LogController.h"
#import "RegisterController.h"
#import "LogView.h"
#import "ForgetController.h"
#import  "LLLockViewController.h" //解锁
@interface LogController ()

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)LogView *head;
@property (nonatomic,retain)LLLockViewController *lockVc;
@end

@implementation LogController

-(LogView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"LogView" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth);
        _head.backgroundColor = HT_BG_COLOR;
        _head.phone.delegate = self;
        _head.passWoord.delegate = self;
        [[HTView shareHTView]setView:_head.logIn cornerRadius:4];
        _head.logIn.backgroundColor = HT_COLOR;
        [[HTView shareHTView]setView:_head.bg_view cornerRadius:4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [_head addGestureRecognizer:tap];
        
    }
    return _head;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   
    
    [self craetTableView];
}


#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 0;}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"logCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self.head.remberPw addTarget:self action:@selector(remberPwAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.head.logIn addTarget:self action:@selector(logInAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.head.forgetPw addTarget:self action:@selector(fogetPwAction) forControlEvents:UIControlEventTouchUpInside];
    [self.head.regiestBtn addTarget:self action:@selector(regiestAction) forControlEvents:UIControlEventTouchUpInside];
    [self.head.eyesBtn addTarget:self action:@selector(eyesAction:) forControlEvents:UIControlEventTouchUpInside];

    self.head.remberPw.selected = [[NSUserDefaults standardUserDefaults]boolForKey:@"remeber_log_PassWord"];
    
    //记住密码时登陆
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"remeber_log_PassWord"]) {
        _head.phone.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"log_userName"];
        _head.passWoord.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"log_passWord"];
    }else {
        
    }
    
    if (self.head.remberPw.selected == YES) {
        
        [_head.remberPw setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateSelected];
    }else
    {
        [_head.remberPw setImage:[UIImage imageNamed:@"checkbox_nomer"] forState:UIControlStateSelected];
    }

    
    return self.head;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{ return kScreenHeigth;}

-(void)eyesAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _head.passWoord.secureTextEntry = NO;
        [_head.eyesBtn setImage:[UIImage imageNamed:@"login_open"] forState:UIControlStateSelected];
    }else
    {
        _head.passWoord.secureTextEntry = YES;
        [_head.eyesBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateSelected];
    }


}

//记住密码
- (void)remberPwAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"remeber_log_PassWord"];
        [_head.remberPw setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateSelected];
    }else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"remeber_log_PassWord"];
        [_head.remberPw setImage:[UIImage imageNamed:@"checkbox_nomer"] forState:UIControlStateSelected];
    }
}


//忘记密码
-(void)fogetPwAction
{
    ForgetController *forgetPw = [[ForgetController alloc]init];
    [self presentViewController:forgetPw animated:NO completion:nil];
}

//立即登陆
- (void)logInAction:(UIButton *)sender
{
    //检测网络
     [HTView isWiffOnView:self.view];
    
    //0.记住密码和账号
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"remeber_log_PassWord"]) {
        
        [self remeberUserAndPassWord];
    }
   
    //1.
    [_head.phone resignFirstResponder];
    [_head.passWoord resignFirstResponder];
    
    //2.
    [[Tools shareTools]progressWithTitle:@"正在登陆..." OnView:self.view];
    
    NSDictionary *dic =@{@"module":@"users",
                         @"q":@"login",
                         @"method":@"post",
                         @"loginname":[Tools utf8:_head.phone.text],
                         @"password":_head.passWoord.text
                         };
    
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
        [[Tools shareTools]hidenHud];
//        NSLog(@"%@",response);
        if ([response[@"result"] isEqualToString:@"success"]) {
            
            //登陆成功->删除手势密码
            [self removeTouchPassw];
            
            //存储user_id
           [[NSUserDefaults standardUserDefaults]setValue:response[@"user_id"] forKey:@"user_id"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
        [HTView alterTitle:response[@"error_remark"]];
            
        }
    
    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];
//        NSLog(@"%@",error);
        
    }];
    
}

//注册
- (void)regiestAction
{
    RegisterController *registVC = [[RegisterController alloc]init];
    [self presentViewController:registVC animated:YES completion:nil];
}

//返回
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}

-(void)tapView
{
    [_head.phone resignFirstResponder];
    [_head.passWoord resignFirstResponder];
}

-(void)craetTableView
{
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth )];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = HT_BG_COLOR;
    
    //buttn
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 30 -15, 28, 30, 30)];
    [back setImage:[UIImage imageNamed:@"log_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    //设置statusbar的颜色
    UIView *statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    statusBarView.backgroundColor = HT_COLOR;
    [self.view addSubview:statusBarView];
    
}

-(void)remeberUserAndPassWord
{
    [[NSUserDefaults standardUserDefaults]setValue:_head.phone.text forKey:@"log_userName"];
    [[NSUserDefaults standardUserDefaults]setValue:_head.passWoord.text forKey:@"log_passWord"];

}


//登陆成功----隐藏手势密码
-(void)removeTouchPassw
{
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"removeLLLockView" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];

}


@end

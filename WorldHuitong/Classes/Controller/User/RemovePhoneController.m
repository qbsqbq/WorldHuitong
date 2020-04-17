//
//  RemovePhoneController.m
//  WorldHuitong
//
//  Created by TXHT on 16/7/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RemovePhoneController.h"
#import "RemovePhoneView.h"
#import "PhoneController.h"
@interface RemovePhoneController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)RemovePhoneView *head;
@end

@implementation RemovePhoneController

-(RemovePhoneView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"RemovePhoneView" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth, 200);
        [[HTView shareHTView]setView:_head.bg_view cornerRadius:4];
        [[HTView shareHTView]setView:_head.removeBtn cornerRadius:4];
        _head.getCoder.backgroundColor = HT_COLOR;
        _head.removeBtn.backgroundColor = [UIColor lightGrayColor];
        _head.removeBtn.userInteractionEnabled = NO;
        
        _head.coderTF.delegate = self;
        _head.logPsaaWord.delegate = self;
        
         [_head.loginColoseBtn addTarget:self action:@selector(loginColoseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_head.logPsaaWord addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        //获取验证码
        [_head.getCoder addTarget:self action:@selector(getCoderAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //解绑
         [_head.removeBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [_head addGestureRecognizer:tap];
    }
    return _head;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"解绑手机号";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.tableFooterView = [[UIView alloc]init];
}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"removePhone";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.head;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{return 200;}


//获取验证码
-(void)getCoderAction:(UIButton *)sender
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    
    NSDictionary *par = nil;
    NSString *arcNumber = [Tools arc];
    NSString *content = [NSString stringWithFormat:@"手机验证码为:%@",arcNumber];
    NSString *contents = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dic = @{
                          @"module":@"phone",
                          @"q":@"unbund_code",
                          @"method":@"post",
                          @"type":@"cancel",
                          @"user_id":[Tools HtUserId],
                          @"code":arcNumber,
                          @"contents":contents
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//        NSLog(@"%@",response);
        
        [[Tools shareTools]hidenHud];
        
        if ([response[@"result"] isEqualToString:@"success"]) {
            
            [[Tools shareTools]progressWithTitle:@"验证码发送成功" Image:kTimage OnView:self.view Hide:2];
            
            //倒计时
            [Tools startTime:sender];
            
        }else{
            
            [HTView alterTitle:response[@"error_remark"]];
        }
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]progressWithTitle:[error description] Image:kFimage OnView:self.view Hide:2];
        [[Tools shareTools]hidenHud];
    }];

}

//解绑
-(void)removeAction
{
    [_head.coderTF resignFirstResponder];
    [_head.logPsaaWord resignFirstResponder];
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    
    NSDictionary *dic = @{
                          @"module":@"phone",
                          @"q":@"unbund_send",
                          @"method":@"post",
                          @"code":_head.coderTF.text,
                          @"paypassword":_head.logPsaaWord.text,
                          @"user_id":[Tools HtUserId]
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
   NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//         NSLog(@"%@",response);
        
        [[Tools shareTools]hidenHud];
        if ([response[@"result"] isEqualToString:@"error"]) {
           
            [HTView alterTitle:response[@"error_remark"]];
        }else{
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"解绑成功！\n是否绑定新的的手机号码？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alter show];
            
        }
     
    } fail:^(NSError *error) {
        
        [[Tools shareTools]progressWithTitle:[error description] Image:kFimage OnView:self.view Hide:2];
        [[Tools shareTools]hidenHud];
    }];

    
}

//是否显示密码
-(void)loginColoseAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _head.logPsaaWord.secureTextEntry = NO;
        [_head.loginColoseBtn setImage:[UIImage imageNamed:@"login_open"] forState:UIControlStateSelected];
    }else
    {
        _head.logPsaaWord.secureTextEntry = YES;
        [_head.loginColoseBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateSelected];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_head.coderTF resignFirstResponder];
    [_head.logPsaaWord resignFirstResponder];
    return YES;
}

-(void)tapView
{
    [_head.coderTF resignFirstResponder];
    [_head.logPsaaWord resignFirstResponder];
}

-(void)valueChanged:(UITextField*)sender
{
    if (![_head.coderTF.text isEqualToString:@""]) {
        if (![sender.text isEqualToString:@""]) {
            _head.removeBtn.backgroundColor = HT_COLOR;
            _head.removeBtn.userInteractionEnabled = YES;
        }else{
            _head.removeBtn.backgroundColor = [UIColor lightGrayColor];
            _head.removeBtn.userInteractionEnabled = NO;
        }
    }

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        
        //跳至根视图，同时通知跳转到绑定手机号码
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        //在需要执行通知方法的地方发出通知
         [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"showPhoneController" object:nil userInfo:nil]];
       
    }else{
    
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

@end

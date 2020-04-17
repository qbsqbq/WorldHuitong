//
//  ForgetController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/10.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "ForgetController.h"
#import "ForgetView.h"
@interface ForgetController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)ForgetView *head;
@end

@implementation ForgetController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = HT_BG_COLOR;
}


#pragma ----UITableViewDataSource----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.bounds.size.height;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _head = [[[NSBundle mainBundle]loadNibNamed:@"ForgetView" owner:self options:nil]lastObject];
    _head.frame = self.view.frame;
    [[HTView shareHTView]setView:_head.bg_voew cornerRadius:4];
    [[HTView shareHTView]setView:_head.comited cornerRadius:4];
    _head.comited.backgroundColor = [UIColor lightGrayColor];
    _head.comited.userInteractionEnabled = NO;
    
    _head.phone.delegate = self;
    _head.passWord.delegate = self;
    _head.verCoder.delegate = self;

    [_head.passWord addTarget:self action:@selector(passWordAction:) forControlEvents:UIControlEventEditingChanged];
    [_head.comited addTarget:self action:@selector(comitedAction) forControlEvents:UIControlEventTouchUpInside];
    [_head.getVerCorder addTarget:self action:@selector(getVerCorderAction:) forControlEvents:UIControlEventTouchUpInside];
    [_head.eyesBtn addTarget:self action:@selector(eyesAction:) forControlEvents:UIControlEventTouchUpInside];

    return _head;
    
}

-(void)passWordAction:(UITextField *)sender
{
    
    if (![_head.phone.text  isEqual: @""] && ![_head.verCoder.text  isEqual: @""]) {
        if (![sender.text isEqualToString:@""]) {
            _head.comited.userInteractionEnabled = YES;
            _head.comited.backgroundColor = HT_COLOR;
        }else {
            _head.comited.userInteractionEnabled = NO;
            _head.comited.backgroundColor = [UIColor lightGrayColor];
        }
    }

}
-(void)eyesAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _head.passWord.secureTextEntry = NO;
        [_head.eyesBtn setImage:[UIImage imageNamed:@"login_open"] forState:UIControlStateSelected];
    }else
    {
        _head.passWord.secureTextEntry = YES;
        [_head.eyesBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateSelected];
    }



}

//获取验证码
-(void)getVerCorderAction:(UIButton *)sender
{
   
    //取消第一响应者
    [self resignFirstRs];
    [[Tools shareTools]progressWithTitle:@"正在发送验证码..." OnView:self.view];
    
    NSString *arcNumber = [Tools arc];
    NSString *content = [NSString stringWithFormat:@"手机验证码为:%@",arcNumber];
    NSString *contents = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *par = nil;
    
    NSDictionary *dic = @{
                          @"module":@"phone",
                          @"q":@"send_code",
                          @"method":@"post",
                          @"code":arcNumber,
                          @"contents":contents,
                          @"type":@"smscode",
                          @"phone":_head.phone.text,
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
        
        [[Tools shareTools]progressWithTitle:[error description] Image:kTimage OnView:self.view Hide:2];
        [[Tools shareTools]hidenHud];

    }];



}


//确定
-(void)comitedAction
{
  [self resignFirstRs];
    
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];

    NSDictionary *dic = @{
                          @"module":@"users",
                          @"q":@"getpwd",
                          @"method":@"post",
                          @"phone_code":_head.verCoder.text,
                          @"phone":_head.phone.text,
                          @"password":_head.passWord.text
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//        NSLog(@"提交修改：%@",response);
        
        [[Tools shareTools]hidenHud];
       
        if ([response[@"result"] isEqualToString:@"success"]) {
           
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"修改成功,快去登陆吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alter show];
            
            
        }else{
            
            [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:@"failure" OnView:self.view Hide:2];
        }
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]progressWithTitle:[error description] Image:@"failure" OnView:self.view Hide:2];
        [[Tools shareTools]hidenHud];
//        NSLog(@"失败：%@",error);
    }];

}



#pragma  ----UIAlertViewDelegate----
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        //创建一个消息对象（指纹解锁失败，登陆密码登陆失败，只好找回密码）。找回成功之后进入首页-目的的是进入登陆界面
        NSNotification * notice = [NSNotification notificationWithName:@"toHomeVC" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }


}
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma ----UITextFieldDelegate----

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstRs];
    return YES;
}



-(void)resignFirstRs
{
    [_head.phone resignFirstResponder];
    [_head.verCoder resignFirstResponder];
    [_head.passWord resignFirstResponder];

}


@end

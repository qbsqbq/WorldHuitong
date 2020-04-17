//
//  RegisterController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RegisterController.h"
#import "RegisterView.h"
#import "emailView.h"
#import "ProtocoController.h"
@interface RegisterController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)RegisterView *head;
@property(nonatomic,strong)emailView *emaile;
@property(nonatomic,assign)BOOL regWayBool;
@property(nonatomic,assign)BOOL agreePhone;        //是否同意
@property(nonatomic,assign)BOOL agreeEmail;        //是否同意


@end

@implementation RegisterController

-(emailView *)emaile
{
    if (!_emaile) {
        _emaile = [[[NSBundle mainBundle]loadNibNamed:@"emailView" owner:self options:nil] lastObject];
        CGRect frame = _head.bg_viewMiddle.frame;
        _emaile.frame = CGRectMake(10, frame.origin.y, kScreenWidth - 20, kScreenHeigth);
        [[HTView shareHTView]setView:_emaile.bg_view cornerRadius:4];
        _emaile.regiesterBtn.backgroundColor = HT_COLOR;
        [[HTView shareHTView]setView:_emaile.regiesterBtn cornerRadius:4];
        [_emaile.regiesterBtn addTarget:self action:@selector(emailRegiesterAction) forControlEvents:UIControlEventTouchUpInside];
        [_emaile.agreeBtn addTarget:self action:@selector(agreeDelegateActi:) forControlEvents:UIControlEventTouchUpInside];
        [_emaile.delegateUrl addTarget:self action:@selector(delegateUrlBtn) forControlEvents:UIControlEventTouchUpInside];
        _emaile.email.delegate = self;
        _emaile.passWord.delegate = self;
        _emaile.referral.delegate = self;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [_head addGestureRecognizer:tap];
    }
    return _emaile;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self customTableView];
    
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _head = [RegisterView registerView];
    _head.phone.delegate = self;
    _head.passWord.delegate = self;
    _head.VerCode.delegate = self;
    _head.Referral.delegate = self;
    
    [_head.liJiRegisted addTarget:self action:@selector(liJiRegiste) forControlEvents:UIControlEventTouchUpInside];
    [_head.shure addTarget:self action:@selector(agreeDelegate:) forControlEvents:UIControlEventTouchUpInside];
    [_head.delegateUrl addTarget:self action:@selector(delegateUrlBtn) forControlEvents:UIControlEventTouchUpInside];
    [_head.getVerCode addTarget:self action:@selector(getVerCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_head.chooseRegWay addTarget:self action:@selector(chooseRegWayAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [_head addGestureRecognizer:tap];
    
    return _head;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.bounds.size.height;
}

-(void)tapView
{
    [self resignFirstRs];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma ----事件处理----

//获取验证码
-(void)getVerCodeAction:(UIButton *)sender
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    
    [self resignFirstRs];
    
    NSDictionary *par = nil;
    NSString *phoneNumber = _head.phone.text;
    
    NSString *arcNumber = [Tools arc];
    NSString *content = [NSString stringWithFormat:@"手机验证码为:%@",arcNumber];
    NSString *contents = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dic = @{@"module":@"phone",
                          @"q":@"send_code",
                          @"reg_type":@"phone",
                          @"method":@"post",
                          @"type":@"reg",
                          @"phone":phoneNumber,
                          @"user_id":@"0",
                          @"code":arcNumber,
                          @"contents":contents
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    par = @{@"diyou":str,@"sign":md5Str};
  
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//        NSLog(@"%@",response[@"result"]);
        
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

//手机注册
-(void)liJiRegiste
{
    [HTView isWiffOnView:self.view];
    if (_agreePhone == NO) {
       
        [HTView alterTitle:@"同意协议才能注册哦！"];
        
    }else{
        
        [[Tools shareTools]progressWithTitle:@"正在注册用户" OnView:self.view];
     
    NSDictionary *dic = @{@"module":@"users",
                          @"q":@"reg_all",
                          @"username":_head.phone.text,
                          @"password":_head.passWord.text,
                          @"reg_type":@"phone",
                          @"method":@"post",
                          @"invite_username":[_head.Referral.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          @"phone":_head.phone.text,
                          @"phone_code":_head.VerCode.text};
        
    NSString *strPar = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:strPar];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":strPar,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response){
       
//        NSLog(@"**************%@",response);

        [[Tools shareTools]hidenHud];
        
        if ([response[@"result"] isEqualToString:@"success"]) {
            
            [self alter];
        }else{
          
            [HTView alterTitle:response[@"error_remark"]];

        }
        
        
    } fail:^(NSError *error) {
        
       [[Tools shareTools]hidenHud];
    }];
    
    
    }
}

//邮箱注册
-(void)emailRegiesterAction
{
    [HTView isWiffOnView:self.view];

    if (_agreeEmail == NO) {
        
        [HTView alterTitle:@"同意协议才能注册哦！"];

    }else{
    
        [[Tools shareTools]progressWithTitle:@"正在注册用户" OnView:self.view];
        NSDictionary *dic = @{@"module":@"users",
                              @"q":@"reg_all",
                              @"username":_emaile.email.text,
                              @"password":_emaile.passWord.text,
                              @"reg_type":@"email",
                              @"method":@"post",
                              @"invite_username":[_emaile.referral.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              @"email":_emaile.email.text};
        
        NSString *strPar = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:strPar];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":strPar,@"sign":md5Str};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//            NSLog(@"%@",response);
            
               [[Tools shareTools]hidenHud];
            
            if ([response[@"result"] isEqualToString:@"success"]) {
            
                [self alter];
            }else{
               
                [HTView alterTitle:response[@"error_remark"]];

            }
 
            
        } fail:^(NSError *error) {
            
            [[Tools shareTools]hidenHud];
        }];

    }
  
    
}

//网络服务协议url
-(void)delegateUrlBtn
{
    ProtocoController *proVC = [[ProtocoController alloc]init];
    [self presentViewController:proVC animated:NO completion:nil];
}

#pragma ----UIActionSheet----
-(void)chooseRegWayAction
{
    [self resignFirstRs];

    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择注册方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机注册",@"邮箱注册", nil];
    [sheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        _head.bg_viewMiddle.hidden = NO;
        _head.shure.hidden = NO;
        _head.delegateUrl.hidden = NO;
        _head.liJiRegisted.hidden = NO;
        self.emaile.hidden = YES;
        
        _head.regWay.text = @"手机注册";
        _regWayBool = YES;
    }
    if (buttonIndex == 1) {
        
         _head.bg_viewMiddle.hidden = YES;
        _head.shure.hidden = YES;
        _head.delegateUrl.hidden = YES;
        _head.liJiRegisted.hidden = YES;
         self.emaile.hidden = NO;
        [_head addSubview:self.emaile];
        _regWayBool = NO;

        _head.regWay.text = @"邮箱注册";
    }

}


#pragma ----UIAlertViewDelegate-----
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//返回按钮
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)customTableView
{
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
}

//手机注册是否同意协议
-(void)agreeDelegate:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _agreePhone  = YES;
        [_head.shure setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateSelected];
    }else
    {
        _agreePhone = NO;
        [_head.shure setImage:[UIImage imageNamed:@"checkbox_nomer"] forState:UIControlStateSelected];
        
    }
    
}

//邮箱注册是否同意协议
-(void)agreeDelegateActi:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _agreeEmail = YES;
        [_emaile.agreeBtn setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateSelected];
    }else
    {
        _agreeEmail = NO;
        [_emaile.agreeBtn setImage:[UIImage imageNamed:@"checkbox_nomer"] forState:UIControlStateSelected];
    }
}

//注销textfiled的响应者
-(void)resignFirstRs
{
    [_head.phone resignFirstResponder];
    [_head.VerCode resignFirstResponder];
    [_head.passWord resignFirstResponder];
    [_head.Referral resignFirstResponder];
    [_emaile.email resignFirstResponder];
    [_emaile.passWord resignFirstResponder];
    [_emaile.referral resignFirstResponder];
}


-(void)alter
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功,快去登陆吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alter show];

}




@end

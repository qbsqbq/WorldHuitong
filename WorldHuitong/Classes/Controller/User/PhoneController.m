//
//  PhoneController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "PhoneController.h"
#import "PhoneView.h"
@interface PhoneController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)PhoneView *head;
@end

@implementation PhoneController

- (void)viewDidLoad {
    
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
    _head = [[[NSBundle mainBundle]loadNibNamed:@"PhoneView" owner:self options:nil]lastObject];
    _head.getCode.backgroundColor = HT_COLOR;
    _head.phoneNumber.delegate = self;
    _head.verCode.delegate = self;
    _head.verify.backgroundColor = [UIColor lightGrayColor];
    [[HTView shareHTView]setView:_head.verify cornerRadius:4];
    [[HTView shareHTView]setView:_head.getCode cornerRadius:0];
    
    //坚挺textFiled的值的变化
    [_head.verCode addTarget:self action:@selector(valueChanage:) forControlEvents:UIControlEventEditingChanged];
    
    
    //获取验证码
    [_head.getCode addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
   
    //手机验证
    [_head.verify addTarget:self action:@selector(verifyAction) forControlEvents:UIControlEventTouchUpInside];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [_head addGestureRecognizer:tap];


    return _head;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.bounds.size.height / 2;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_head.phoneNumber resignFirstResponder];
    [_head.verCode resignFirstResponder];
    return YES;
}

-(void)tapView
{
    [_head.phoneNumber resignFirstResponder];
    [_head.verCode resignFirstResponder];
}
-(void)valueChanage:(UITextField*)textField
{
    if ([textField.text isEqualToString:@""]) {
        _head.verify.backgroundColor = [UIColor lightGrayColor];
        _head.verify.enabled = NO;
    }else{
        _head.verify.backgroundColor = HT_COLOR;
        _head.verify.enabled = YES;
    
    }


}

//获取验证码
-(void)getCodeAction:(UIButton *)sender
{
    [_head.phoneNumber resignFirstResponder];
    [_head.verCode resignFirstResponder];
    
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *par = nil;
    NSString *phoneNumber = _head.phoneNumber.text;
    
    NSString *arcNumber = [Tools arc];
    NSString *content = [NSString stringWithFormat:@"手机验证码为:%@",arcNumber];
    NSString *contents = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dic = @{@"module":@"phone",
                          @"q":@"approve_code",
                          @"method":@"post",
                          @"type":@"add",
                          @"phone":phoneNumber,
                          @"user_id":[Tools HtUserId],
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
            [[Tools shareTools]progressWithTitle:@"验证码发送成功" Image:kTimage OnView:self.view Hide:1];
            
            //倒计时
            [Tools startTime:sender];
            
        }else{
            
            [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:@"failure" OnView:self.view Hide:2];
        }
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]progressWithTitle:[error description] Image:kFimage OnView:self.view Hide:1];
        [[Tools shareTools]hidenHud];
    }];

}

//手机验证
-(void)verifyAction
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    [_head.phoneNumber resignFirstResponder];
    [_head.verCode resignFirstResponder];
    
    NSDictionary *dic= @{
                         @"method":@"post",
                         @"module":@"phone",
                         @"q":@"approve_send",
                         @"user_id":[Tools HtUserId],
                         @"type":@"add",
                         @"code":_head.verCode.text,
                         @"phone":_head.phoneNumber.text
                         };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response){
//        NSLog(@"%@",response);
        
        [[Tools shareTools]hidenHud];
        if ([response[@"result"] isEqualToString:@"success"]) {
            
            [[Tools shareTools]progressWithTitle:@"验证成功" Image:kTimage OnView:self.view Hide:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];

            });

        }else{
        
            [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:kFimage OnView:self.view Hide:1];
        }
        
    } fail:^(NSError *error) {
        [[Tools shareTools]hidenHud];

    }];
}


-(void)customTableView
{
    self.view.backgroundColor = HT_BG_COLOR;
    self.navigationItem.title = @"绑定手机号码";
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    
}


@end

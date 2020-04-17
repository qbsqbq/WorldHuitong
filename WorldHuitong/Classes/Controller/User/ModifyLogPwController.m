//
//  ModifyLogPwController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//修改登陆密码


#import "ModifyLogPwController.h"
#import "ModifLogPwView.h"

@interface ModifyLogPwController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ModifLogPwView *head;
@end

@implementation ModifyLogPwController


-(ModifLogPwView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"ModifLogPwView" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64);
        [[HTView shareHTView]setView:_head.shureModif cornerRadius:4];
        _head.shureModif.backgroundColor = [UIColor lightGrayColor];
        [_head.shureModif addTarget:self action:@selector(shureModifAction) forControlEvents:UIControlEventTouchUpInside];
        _head.oldPw.delegate = self;
        _head.lastPw.delegate = self;
        _head.shurePw.delegate = self;
        _head.shureModif.userInteractionEnabled = NO;
        
        [_head.oldPw addTarget:self action:@selector(valueChanage) forControlEvents:UIControlEventEditingChanged];
        [_head.oldPw addTarget:self action:@selector(valueChanage) forControlEvents:UIControlEventEditingChanged];
        [_head.shurePw addTarget:self action:@selector(valueChanage) forControlEvents:UIControlEventEditingChanged];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [_head addGestureRecognizer:tap];
    }
    return _head;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatTableView];
    
    
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
    
    return self.head;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenHeigth - 64;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstRes];
    return YES;
}

-(void)tapView
{
    [self resignFirstRes];
}

/**确认修改**/
-(void)shureModifAction
{
    [self resignFirstRes];
    
    NSString *oldPw = _head.oldPw.text;
    NSString *lastPw = _head.lastPw.text;
    NSString *shurePw = _head.shurePw.text;
    
    if (![lastPw isEqualToString:shurePw]) {

        [[Tools shareTools]progressWithTitle:@"两次输入密码不相同" Image:@"failure" OnView:self.view Hide:2];
    }else{
    
        [[Tools shareTools]progressWithTitle:@"请稍后..." OnView:self.view];

        NSDictionary *dic = @{
                              @"module":@"users",
                              @"q":@"update_password",
                              @"method":@"post",
                              @"user_id":[Tools HtUserId],
                              @"oldpassword":oldPw,
                              @"password":lastPw
                              };
        NSString *str = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:str];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
        
//        NSLog(@"%@",par);
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
            
//            NSLog(@"%@",response);
            [[Tools shareTools]hidenHud];
            
            if ([response[@"result"] isEqualToString:@"success"]) {
                [[Tools shareTools]progressWithTitle:@"修改成功！" Image:kTimage OnView:self.navigationController.view Hide:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:kFimage OnView:self.navigationController.view Hide:2];
            }
            
        } fail:^(NSError *error) {
           
            [[Tools shareTools]hidenHud];
        }];

    }
}

-(void)valueChanage
{
    if ([_head.oldPw.text isEqualToString:@""] || [_head.lastPw.text isEqualToString:@""] || [_head.shurePw.text isEqualToString:@""] ) {
        _head.shureModif.backgroundColor = [UIColor lightGrayColor];
        _head.shureModif.userInteractionEnabled = NO;
    }else{
    
        _head.shureModif.backgroundColor = HT_COLOR;
        _head.shureModif.userInteractionEnabled = YES;
        
    }

}

-(void)creatTableView
{
    self.navigationItem.title = @"修改登陆密码";
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];


}

-(void)resignFirstRes
{
    [_head.oldPw resignFirstResponder];
    [_head.lastPw resignFirstResponder];
    [_head.shurePw resignFirstResponder];

}
@end

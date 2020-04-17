//
//  TouchIDController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/12.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "TouchIDController.h"
#import <UIKit/UIKit.h>
@interface TouchIDController ()
@property (strong, nonatomic) UISwitch *switchBtn;
@property(nonatomic,strong)UIAlertView *alterBoth;
@property(nonatomic,strong)UIAlertView *alterOff;




@end

@implementation TouchIDController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self creatTableView];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 1;}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
    head.backgroundColor = [UIColor clearColor];
    return head;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] ;
    }
    cell.textLabel.text = @"指纹解锁";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     self.switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 5, 60, 34)];
    
    BOOL ison = [[NSUserDefaults standardUserDefaults]boolForKey:@"OntouchId"];
    _switchBtn.on = ison;
    [_switchBtn addTarget:self action:@selector(openTouchIdAction:)forControlEvents:UIControlEventValueChanged];
    [cell addSubview:_switchBtn];

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{return 24;}


//是否打开指纹解锁
-(void)openTouchIdAction:(UISwitch *)sender
{
    //获取手势密码
    NSString *pswd = [LLLockPassword loadLockPassword];
   
        if (sender.isOn == YES && pswd) {
            
            //开启指纹，关闭手势
           _alterBoth = [[UIAlertView alloc]initWithTitle:nil message:@"继续开启指纹解锁\n 将关闭手势解锁" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_alterBoth show];
            
        }else if (sender.isOn == NO){
            
            //关闭指纹
            _alterOff = [[UIAlertView alloc]initWithTitle:nil message:@"确定关闭指纹解锁" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关闭", nil];
            [_alterOff show];
            
        }else if (sender.isOn == YES && !pswd){
        
            //打开指纹解锁
            [self touchIDAction];
        }
}


//打开指纹解锁
-(void)touchIDAction
{
    //步骤1：检查Touch ID是否可用
    LAContext *authenticationContext= [[LAContext alloc]init];
    NSError *error = [[NSError alloc]init];
    BOOL isTouchIdAvallble = [authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (isTouchIdAvallble) {
        
        //步骤2：获取指纹验证结果
        [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"OntouchId"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[Tools shareTools]progressWithTitle:@"成功开启指纹解锁" Image:kTimage OnView:self.navigationController.view Hide:1];
                });
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _switchBtn.on = NO;
                    [[Tools shareTools]progressWithTitle:@"开启指纹解锁失败" Image:kFimage OnView:self.navigationController.view Hide:1];
                });
            }
        }];
        
    }else{
    
            [[Tools shareTools]progressWithTitle:@"Touch ID不可以使用" Image:kFimage OnView:self.navigationController.view Hide:2];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _alterOff) {
        
        if (buttonIndex == 1) {
            
            //关闭指纹解锁
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"OntouchId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            _switchBtn.on = YES;
        
        }
    }
    
    if (alertView == _alterBoth) {
        
        if (buttonIndex == 1) {
            
            //打开指纹解锁
            [self touchIDAction];
            
            //关闭手势
             [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"lock"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            _switchBtn.on = NO;
        
        }
    }
}


-(void)creatTableView
{
    self.navigationItem.title = @"指纹密码";
    BOOL ison = [[NSUserDefaults standardUserDefaults]boolForKey:@"OntouchId"];
    _switchBtn.on = ison;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = HT_BG_COLOR;
    [self.tableView reloadData];

}

@end

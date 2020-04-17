//
//  MJGPassWordViewController.m
//  HHBank
//
//  Created by 中科金财 on 16/4/7.
//  Copyright © 2016年 SINO. All rights reserved.
//

#import "MJGPassWordViewController.h"
#import "LLLockViewController.h"
#import "LogController.h"
@interface MJGPassWordViewController ()
{
    NSArray* heightArray;
}

@property (nonatomic,retain)UITableView *settingTableView;
@property (nonatomic,retain)NSArray *titleArray;
@property (nonatomic,retain)UISwitch *mySwitch;
@property (nonatomic,retain) UISwitch *switc;



@end

@implementation MJGPassWordViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([LLLockPassword loadLockPassword]) {
        self.mySwitch.on = YES;
        self.titleArray = @[@"手势密码",@"更改密码"];
    } else {
        self.mySwitch.on = NO;
        self.titleArray = @[@"手势密码"];
    }
    [self.settingTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"手势密码";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.settingTableView = tableView;
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(presentLogVC:) name:@"ChangeNameNotification" object:nil];
    
}

- (void)presentLogVC:(id)sender
{
    LogController *logVC = [[LogController alloc]init];
    [self presentViewController:logVC animated:NO completion:nil];
    //    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([LLLockPassword loadLockPassword]) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ident = @"SettingCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
        
        _switc = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60, 7, 50, 0)];
        _switc.tag = 200;
        _switc.hidden = NO;
        [_switc addTarget:self action:@selector(mySwitchHandle:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:_switc];
        
    }
    UISwitch *mswith = (UISwitch *)[cell viewWithTag:200];
    self.mySwitch = mswith;
    
    if ([LLLockPassword loadLockPassword]) {
        self.mySwitch.on = YES;
    }else{
        self.mySwitch.on = NO;
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    if (indexPath.row == 1) {
        self.mySwitch.hidden = YES;
    }else{
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    cell.clipsToBounds = YES;
    return cell;
}


//点击mySwitch触发
- (void)mySwitchHandle:(UISwitch *)mySwitch
{
    //设置导航栏
    [self setNavigationBar];
    
    //获取指纹解锁状态
    BOOL isOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"OntouchId"];
    
    if (isOn && ![LLLockPassword loadLockPassword]) {
        
        //关闭指纹，打开手势
        UIAlertView*alterBoth = [[UIAlertView alloc]initWithTitle:nil message:@"继续开启手势解锁\n 将关闭指纹解锁" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterBoth show];
        
    }else if (isOn == NO && ![LLLockPassword loadLockPassword]) {
       
        //创建手势解锁
        [self pushToLLLockViewController:LLLockViewTypeCreate];
        self.titleArray = @[@"手势密码",@"更改密码"];
        [LLLockPassword setLockPassWordTag];
        
    }else if([LLLockPassword loadLockPassword]){
    
        //清除手势解锁
        [self pushToLLLockViewController:LLLockViewTypeClean];
        self.titleArray = @[@"手势密码"];
        [LLLockPassword removeLockPassWordTag];
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置导航栏
    [self setNavigationBar];
    
    if (indexPath.row == 1) {
      
        //修改
        [self pushToLLLockViewController:LLLockViewTypeModify];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - 弹出手势解锁密码输入框
- (void)pushToLLLockViewController:(LLLockViewType)type
{
    self.lockVc = [[LLLockViewController alloc] init];
    self.lockVc.nLockViewType = type;
    self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:self.lockVc animated:YES];
   
}

//设置导航栏
- (void)setNavigationBar
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -300) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
       
         //关闭指纹，
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"OntouchId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //打开手势
        [self pushToLLLockViewController:LLLockViewTypeCreate];
        self.titleArray = @[@"手势密码",@"更改密码"];
        [LLLockPassword setLockPassWordTag];
    }


}

@end

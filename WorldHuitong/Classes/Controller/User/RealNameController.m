//
//  RealNameController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//实名认证

#import "RealNameController.h"
#import "RealNameView.h"
@interface RealNameController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)RealNameView *head;


@end

@implementation RealNameController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatTableView];
}


#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 0;}

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
    _head = [RealNameView realNameView];
    _head.realName.delegate = self;
    _head.IDNumber.delegate = self;
    [_head.realName addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
     [_head.IDNumber addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    [_head.submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_head.realName resignFirstResponder];
    [_head.IDNumber resignFirstResponder];
    return YES;
}

-(void)tapView
{
    [_head.realName resignFirstResponder];
    [_head.IDNumber resignFirstResponder];
}

-(void)changeValue:(UITextField*)sender
{
    if ([_head.IDNumber.text isEqualToString:@""] || [_head.realName.text isEqualToString:@""]) {
        _head.submit.backgroundColor = [UIColor lightGrayColor];
        _head.submit.enabled = NO;
    }
    else{
        _head.submit.backgroundColor = HT_COLOR;
        _head.submit.enabled = YES;
    }
}

/**提交按钮**/
-(void)submitAction
{
    [[Tools shareTools]progressWithTitle:@"正在提交..." OnView:self.navigationController.view];
    [_head.realName resignFirstResponder];
    [_head.IDNumber resignFirstResponder];
    NSDictionary *dic = @{
                          @"module":@"approve",
                          @"q":@"mobile_add_realname",
                          @"method":@"post",
                          @"user_id":[Tools HtUserId],
                          @"realname":[Tools utf8:_head.realName.text],
                          @"card_id":_head.IDNumber.text
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
      
        [[Tools shareTools]hidenHud];
        if ([response[@"result"] isEqualToString:@"success"]) {
          
            [[Tools shareTools]progressWithTitle:@"认证成功" Image:kTimage OnView:self.view Hide:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
        
            [[Tools shareTools]progressWithTitle:response[@"error_remark"] Image:kFimage OnView:self.navigationController.view Hide:2];
        }
        
//        NSLog(@"%@",response);
   
    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];

        [[Tools shareTools]progressWithTitle:error.description Image:kFimage OnView:self.navigationController.view Hide:2];
    }];
    
}


-(void)creatTableView
{
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    self.navigationItem.title = @"实名认证";
}


-(NSString *)encodeURL:(NSString*) unescapedString
{
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                   (CFStringRef)unescapedString,
                                                                                   NULL,
                                                                                   NULL,
                                                                                kCFStringEncodingUTF8));
    

    return encodedString;
}




@end

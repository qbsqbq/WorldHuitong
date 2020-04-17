//
//  NewBiaoDetaileController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/17.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "NewBiaoDetaileController.h"
#import "NewBiaoBuyController.h"
#import "NewDetaileCell.h"
@interface NewBiaoDetaileController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *yijianBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NewDetaileCell *head;


@end

@implementation NewBiaoDetaileController

-(NewDetaileCell *)head
{
    if (!_head) {
         _head = [[[NSBundle mainBundle]loadNibNamed:@"NewDetaileCell" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth, _head.hqsy_detaile.frame.origin.y + 55);
        _head.head_line.backgroundColor = HT_BG_COLOR;
        _head.foot_line.backgroundColor = HT_BG_COLOR;
        _head.biao_apr.text  = [_xinBiao.borrow_apr stringByAppendingString:@"%"];
        _head.biao_data.text = [NSString stringWithFormat:@"%@",_xinBiao.borrow_period_name];

        _head.lable1.layer.cornerRadius = (kScreenWidth - 80) / 8;
        _head.lable1.layer.masksToBounds = YES;
        
        _head.lable2.layer.cornerRadius = (kScreenWidth - 80) / 8;
        _head.lable2.layer.masksToBounds = YES;
        _head.lable2.text = @"天下汇通\n服务平台";
        
        _head.lable4.layer.cornerRadius = (kScreenWidth - 80) / 8;
        _head.lable4.layer.masksToBounds = YES;
        _head.lable4.text = @"得到\n体验金";
        
        _head.lable5.layer.cornerRadius = (kScreenWidth - 80) / 8;
        _head.lable5.layer.masksToBounds = YES;
        _head.lable5.text = @"投资\n体验标";
 
        
        if ([_xinBiao.account floatValue] >= 10000) {
            _head.amount.text = [NSString stringWithFormat:@"%.f万",[_xinBiao.account floatValue] / 10000];
        }else{
            _head.amount.text = [NSString stringWithFormat:@"%@元",_xinBiao.account];
        }
    }
    
    return _head;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self creatTableView];
 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 0;}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *ID = @"CELL";
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
    return self.head.hqsy_detaile.frame.origin.y + 155;
}


- (IBAction)yijianBuy:(id)sender {
    
    if (!kUSER_ID) {
        
        LogController *log = [[LogController alloc]init];
        [self presentViewController:log animated:YES completion:nil];
    }else{
    
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"buyNewBiao"] isEqualToString:@"yes"]) {
            
            [Tools alterWithTitle:@"该项目仅限首次投资用户,\n请您投资其他项目"];
        }else{
            self.hidesBottomBarWhenPushed = YES;
            [self performSegueWithIdentifier:@"NewBiaoBuyController" sender:nil];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewBiaoBuyController"])  //认购界面
    {
        NewBiaoBuyController *detailVC = segue.destinationViewController;
        detailVC.borrow_nid = _xinBiao.borrow_nid;
    }
   
}


-(void)creatTableView
{
    UILabel *navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    navTitle.text = _xinBiao.name;
    self.navigationItem.titleView = navTitle;
    
    self.view.backgroundColor = HT_BG_COLOR;
    _yijianBtn.backgroundColor = HT_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    
}




@end

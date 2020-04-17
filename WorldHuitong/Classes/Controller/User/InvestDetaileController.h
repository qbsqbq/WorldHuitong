//
//  InvestDetaileController.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InverstedBiao.h"
@interface InvestDetaileController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//@property(nonatomic,assign)NSString *borrow_nid;   //借款id
//@property(nonatomic,assign)int ID;                 //投资id
@property(nonatomic,strong)InverstedBiao *biao;    //标



@end

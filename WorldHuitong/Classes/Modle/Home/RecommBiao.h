//
//  RecommBiao.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommBiao : NSObject

/**总额**/
@property(nonatomic,strong)NSString *account;

/**利息**/
@property(nonatomic,strong)NSString *borrow_apr;

/**borrow_nid**/
@property(nonatomic,strong)NSString *borrow_nid;

/**标的类型**/
@property(nonatomic,strong)NSString *borrow_type;

/**标的名称**/
@property(nonatomic,strong)NSString *name;

/**标的完成进度**/
@property(nonatomic,strong)NSString *borrow_account_scale;

/**周期**/
@property(nonatomic,strong)NSString *borrow_period;




@end

//
//  DetaileBiao.h
//  WorldHuitong
//
//  Created by TXHT on 16/5/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetaileBiao : NSObject

/**借款标的nid**/
@property(nonatomic,strong)NSString *borrow_nid;

/**流转标的最小流转金额**/
@property(nonatomic,assign)float account_min;

/**借款人的user_id**/
@property(nonatomic,strong)NSString *user_id;

/**借款标介绍**/
@property(nonatomic,strong)NSString *borrow_contents;




@end

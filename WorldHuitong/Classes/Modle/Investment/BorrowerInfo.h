//
//  BorrowerInfo.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//借款人的信息

#import <Foundation/Foundation.h>

@interface BorrowerInfo : NSObject

/**用户头像**/
@property(nonatomic,strong)NSString *avatar_url;

/**性别**/
@property(nonatomic,strong)NSString *sex;

/**月收入**/
@property(nonatomic,strong)NSString *income_name;

/**出生日期**/
@property(nonatomic,strong)NSString *birthday;

/**是否结婚**/
@property(nonatomic,strong)NSString *marry_status_name;

/**工作城市**/
@property(nonatomic,strong)NSString *work_city;

/**学历**/
@property(nonatomic,strong)NSString *edu;

/**工作年限**/
@property(nonatomic,strong)NSString *work_year;

/**公司性值**/
@property(nonatomic,strong)NSString *company_type_name;

/**有无购房**/
@property(nonatomic,strong)NSString *house_status;

/**公司规模**/
@property(nonatomic,strong)NSString *company_size;

/**有无购车**/
@property(nonatomic,strong)NSString *is_car;

/**用户级别**/
@property(nonatomic,strong)NSString *credit_rank;

/**岗位职称**/
@property(nonatomic,strong)NSString *company_position;



@end

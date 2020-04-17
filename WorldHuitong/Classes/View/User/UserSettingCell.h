//
//  UserSettingCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface UserSettingCell : UITableViewCell
@property(nonatomic,assign)BOOL boolShuangQian;

+(instancetype)UserSettingCellWithTableView:tableView IndexPath:indexPath Modle:_user OpenAccount:(NSString *)open SecondOffer:(NSString *)second;

//认证
+(void)FCell:(UITableViewCell*)cell;
+(void)TCell:(UITableViewCell*)cell;

//设置
+(void)SCell:(UITableViewCell*)cell;
+(void)NSCell:(UITableViewCell*)cell;

@end

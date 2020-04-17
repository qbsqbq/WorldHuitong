//
//  TenderCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/4/21.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Biao.h"
@interface TenderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**标的类型图片**/
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;

/**标的名称**/
@property (weak, nonatomic) IBOutlet UILabel *title;

/**标的盈利率**/
@property (weak, nonatomic) IBOutlet UILabel *rate;

/**标的周期**/
@property (weak, nonatomic) IBOutlet UILabel *time;

/**标的总额**/
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;

/**放置投标进度的view**/
@property (weak, nonatomic) IBOutlet UIView *bg_progress;

-(instancetype)tenderCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath Modle:(Biao*)biao;

@property(nonatomic,strong)UIImageView *icon_imageView;

@end

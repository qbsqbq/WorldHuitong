//
//  NewBiaotiyanCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//新标体验cell

#import <UIKit/UIKit.h>

@interface NewBiaotiyanCell : UITableViewCell

/**标名**/
@property (weak, nonatomic) IBOutlet UILabel *biaoName;

/*标的利息**/
@property (weak, nonatomic) IBOutlet UILabel *biao_reta;

@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**立即购买**/
@property (weak, nonatomic) IBOutlet UIButton *lijiBuy;

+ (instancetype)newBiaotiyancellWith:(UITableView *)tableView;

@end

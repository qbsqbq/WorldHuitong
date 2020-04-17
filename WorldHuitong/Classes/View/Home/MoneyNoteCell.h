//
//  MoneyNoteCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/2.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyNote.h"

@interface MoneyNoteCell : UITableViewCell

/**类型名**/
@property (weak, nonatomic) IBOutlet UILabel *title;

/**时间**/
@property (weak, nonatomic) IBOutlet UILabel *time;

/**总额**/
@property (weak, nonatomic) IBOutlet UILabel *account;

/**状态名**/
@property (weak, nonatomic) IBOutlet UILabel *state_name;

+(instancetype)MoneyNoteCellWithIndexPath:(NSIndexPath*)indexPath Modle:( MoneyNote *)modle Who:(NSString *)who;

@end

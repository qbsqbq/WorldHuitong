//
//  ShopListCell.h
//  WorldHuitong
//
//  Created by TXHT on 16/8/24.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListCell : UITableViewCell

/**商品图片**/
@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;

/**商品名称**/
@property (weak, nonatomic) IBOutlet UILabel *shopName;

/**积分数量**/
@property (weak, nonatomic) IBOutlet UILabel *jifenNumbe;

/**商品市场价**/
@property (weak, nonatomic) IBOutlet UILabel *nomarPrice;


@end

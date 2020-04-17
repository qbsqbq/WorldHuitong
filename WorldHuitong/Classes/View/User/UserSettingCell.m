//
//  UserSettingCell.m
//  WorldHuiton
//
//  Created by TXHT on 16/4/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "UserSettingCell.h"
#import "SDWebImageManager.h"

@implementation UserSettingCell


+(instancetype)UserSettingCellWithTableView:(UITableView*)tableView IndexPath:(NSIndexPath*)indexPath Modle:(User*)modle OpenAccount:(NSString *)open SecondOffer:(NSString *)second
{
    static NSString *ID = @"UserSettingCell";
    UserSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.detailTextLabel.text = @"";

    if (indexPath.section == 0) {
        cell.textLabel.text = @[@"手机认证",@"实名认证",@"双乾托管认证",@"二次授权",@"注册成功",@"银行卡认证"][indexPath.row];
        if (indexPath.row == 0) {
            
            if ([modle.phone_status isEqualToString:@"0"]) {      //手机认证
                [self FCell:cell];
            }else{
                [self TCell:cell];
            }
        }
        if (indexPath.row == 1) {
            if ([modle.realname_status isEqualToString:@"-1"]) {   //实名认证
                
                [self FCell:cell];
            }else if([modle.realname_status isEqualToString:@"0"]){
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = @"审核中...";
            }else{
                
                [self TCell:cell];
            }
            
        }
        if (indexPath.row == 2) {                //双乾托管认证
            if ([open isEqualToString:@"error"]) {
                
                [self FCell:cell];
            }else{
             
                [self TCell:cell];
            }
        }
        if (indexPath.row == 3) {                 //二次授权
            if ([second isEqualToString:@"error"]) {
                [self FCell:cell];
            }else{
                [self TCell:cell];
            }
        }
        if (indexPath.row == 4) {                 //注册成功
            if (![open isEqualToString:@"error"] && ![second isEqualToString:@"error"]) {
                [self TCell:cell];
            }else{
                [self FCell:cell];
            }
        }
        if (indexPath.row == 5) {                 //银行卡认证
            
            if ([modle.bank_status isEqualToString:@"0"]) {
                [self FCell:cell];
            }else{
                [self TCell:cell];
            }
            
        }
        
        
    }
    if (indexPath.section == 1) {
       
        cell.textLabel.text = @[@"登陆密码",@"解锁密码",@"交易密码"][indexPath.row];

        if (indexPath.row == 0 || indexPath.row == 1) {
            cell.detailTextLabel.text = @"";
        }

    }
    if (indexPath.section == 2) {
       
        cell.textLabel.text = @"清除缓存";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        NSInteger tmpSize = [[SDImageCache sharedImageCache] getDiskCount];
        if (tmpSize >= 1) {
        
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldM",tmpSize];
            
        }else{
        
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldK",tmpSize];
        
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;

}


+(void)FCell:(UITableViewCell*)cell
{
    cell.detailTextLabel.text = @"未认证";
    cell.detailTextLabel.textColor = HT_WCOLOR;
}


+(void)TCell:(UITableViewCell*)cell
{
    cell.detailTextLabel.text = @"已认证";
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
}

+(void)SCell:(UITableViewCell*)cell
{
    cell.detailTextLabel.text = @"已设置";
//    cell.detailTextLabel.textColor = HT_TCOLOR;
}


+(void)NSCell:(UITableViewCell*)cell
{
    cell.detailTextLabel.text = @"未设置";
    cell.detailTextLabel.textColor = HT_WCOLOR;
}

@end

//
//  InverstedBiao.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/19.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "InverstedBiao.h"

@implementation InverstedBiao

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{@"inveterId":@"id"};
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}
@end

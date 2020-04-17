//
//  NSString+Phone.h
//  WorldHuitong
//
//  Created by TXHT on 16/6/17.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Phone)

-(BOOL)checkPhoneNumInput;
+ (BOOL)validatePhone:(NSString *)phone;
@end

//
//  NSURL+Category.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/16.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "NSURL+Category.h"

@implementation NSURL (Category)


+ (NSURL *)URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters{
    
    NSMutableString *urlString =[NSMutableString string];   //The URL starts with the base string[urlString appendString:baseString];
    
    [urlString appendString:baseString];
    
    NSString *escapedString;
    
    NSInteger keyIndex = 0;
    
    for (id key in parameters) {
        
        //First Parameter needs to be prefixed with a ? and any other parameter needs to be prefixed with an &
        if(keyIndex ==0) {
            escapedString =(NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[parameters valueForKey:key], NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
            
            [urlString appendFormat:@"?%@=%@",key,escapedString];
            
        }else{
            escapedString =(NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[parameters valueForKey:key], NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
            
            [urlString appendFormat:@"&%@=%@",key,escapedString];
        }
        keyIndex++;
    }
    return [NSURL URLWithString:urlString];
}

@end

//
//  ProtocoController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/9.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "ProtocoController.h"

@interface ProtocoController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ProtocoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.view];

    self.view.backgroundColor = HT_BG_COLOR;
    
    NSDictionary *dic = @{@"module":@"articles",
                          @"q":@"get_one_page",
                          @"nid":@"privacy",
                          @"method":@"get"
                          };
    
    NSString *strPar = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:strPar];
    NSString *md5Str = [[Tools shareTools] md5:htStr];
    NSDictionary *par = @{@"diyou":strPar,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
        [_webView loadHTMLString:response[@"contents"] baseURL:nil];
    
    } fail:^(NSError *error) {
       
    }];
    
    
    
    
    
}


- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  BiaoIntroduceController.m
//  WorldHuitong
//
//  Created by TXHT on 16/6/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "BiaoIntroduceController.h"
#import "NSString+Category.h"
@interface BiaoIntroduceController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation BiaoIntroduceController

-(UIWebView *)webView
{
    if (!_webView) {
        if ([_vcType isEqualToString:@"home"]) {
            _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth)];
        }else{
            _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64)];
        }
        _webView.delegate = self;
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.backgroundColor = HT_BG_COLOR;
    }
    return _webView;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"借款标介绍";
    [self.webView loadHTMLString:_borrow_contents baseURL:nil];
    [self.view addSubview:self.webView];

}


#pragma ----UIWebViewDelegate----
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[Tools shareTools]progressWithTitle:@"拼命加载中..." OnView:self.view];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{    
    [[Tools shareTools]hidenHud];
}


@end

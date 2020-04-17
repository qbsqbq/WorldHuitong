//
//  ZiJingDaoZahngController.m
//  WorldHuitong
//
//  Created by TXHT on 16/6/20.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "ZiJingDaoZahngController.h"

@interface ZiJingDaoZahngController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;


@end

@implementation ZiJingDaoZahngController

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        if ([_vcType isEqualToString:@"home"]) {
            _webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth);
        }else{
            _webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64);
        }
        _webView.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor  = HT_BG_COLOR;
        _webView.delegate = self;

        NSURL *url = [NSURL URLWithString:_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    return _webView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [HTView isWiffOnView:self.webView];
    self.navigationItem.title = _headTitle;
    [self.view addSubview:self.webView];

}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[Tools shareTools]progressWithTitle:@"拼命加载中..." OnView:self.view];
}
/**
 *  控制webView缩放的代码-js
 */

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=3.0, minimum-scale=1.0, user-scalable=yes\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
    
    [[Tools shareTools]hidenHud];

}






@end

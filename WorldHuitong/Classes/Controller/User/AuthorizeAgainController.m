//
//  AuthorizeAgainController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/18.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "AuthorizeAgainController.h"

@interface AuthorizeAgainController ()
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation AuthorizeAgainController

-(UIWebView *)webView
{
    if (!_webView) {
        _webView= [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.delegate = self;
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"二次授权";
    self.view.backgroundColor = [UIColor whiteColor];
     NSURL *url = [NSURL URLWithString:_url];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     [self.webView loadRequest:request];
//    NSLog(@"%@",_url);

}



-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[Tools shareTools]progressWithTitle:@"拼命加载中..." OnView:self.view];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title;"];
    [[Tools shareTools]hidenHud];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //获取请求的绝对路径.
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding];
    
    if ([urlString rangeOfString:@"result"].location != NSNotFound) {
        
        
        if([urlString rangeOfString:@"success"].location != NSNotFound)//_roaldSearchText
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HTView alterTitle:@"恭喜您,二次授权成功！" WithTimer:2];
            });
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HTView alterTitle:[urlString substringFromIndex:7] WithTimer:0];
            });
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    

    
    
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    return  YES;



}



@end

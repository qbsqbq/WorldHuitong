//
//  RechargeDetaileController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/27.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RechargeDetaileController.h"

@interface RechargeDetaileController ()
@property(nonatomic,strong)UIWebView *czWebView;

@end

@implementation RechargeDetaileController




- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    [self creatWebView];
    

    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[Tools shareTools]progressWithTitle:@"拼命加载中..." OnView:self.view];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [self.czWebView stringByEvaluatingJavaScriptFromString:@"document.title;"];
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
            [[Tools shareTools]progressWithTitle:@"恭喜您,充值成功" Image:kTimage OnView:self.view Hide:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
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



-(void)creatWebView
{
    _czWebView = [[UIWebView alloc]init];
    _czWebView.frame = CGRectMake(0, -48, kScreenWidth, kScreenHeigth + 40);
    _czWebView.backgroundColor = [UIColor whiteColor];
    _czWebView.delegate = self;
    _czWebView.scalesPageToFit = YES;
    
    [_czWebView.scrollView setBounces:NO];
    _czWebView.mediaPlaybackAllowsAirPlay = YES;
    _czWebView.mediaPlaybackRequiresUserAction = YES;
    
    NSURL *shangQianUrl = [[NSURL alloc]initWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:shangQianUrl];
    [_czWebView loadRequest:request];
    [self.view addSubview:_czWebView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.hidesBottomBarWhenPushed = YES;

}


@end

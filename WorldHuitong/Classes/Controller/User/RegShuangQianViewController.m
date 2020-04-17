//
//  RegShuangQianViewController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/17.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RegShuangQianViewController.h"
#import "NSString+Category.h"
@interface RegShuangQianViewController ()
@property(nonatomic,strong)UIWebView *sqWebView;

/**
 -  存储data数据
 */
@property(nonatomic,strong)NSMutableData *dataM;
@end

@implementation RegShuangQianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self creatWebView];

//    NSLog(@"%@",_url);
   
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[Tools shareTools]progressWithTitle:@"拼命加载中..." OnView:self.view];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    [[Tools shareTools]hidenHud];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[Tools shareTools]hidenHud];

}
-(void)creatWebView
{
    _sqWebView = [[UIWebView alloc]init];
    _sqWebView.frame = CGRectMake(0, -48, kScreenWidth, kScreenHeigth + 88 );
    _sqWebView.delegate = self;
    _sqWebView.scalesPageToFit = YES;
    
    [_sqWebView.scrollView setBounces:NO];
    _sqWebView.mediaPlaybackAllowsAirPlay = YES;
    _sqWebView.mediaPlaybackRequiresUserAction = YES;
    
    NSString *urlStr = [self IsChinese:_url];
    NSURL *shangQianUrl = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:shangQianUrl];
    [_sqWebView loadRequest:request];
    //发送请求
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self.view addSubview:_sqWebView];
    
}

//判断是否有中文-有就加密
-(NSString*)IsChinese:(NSString *)str
{
    int numbers = 0;
    int stard = 0;
    for(int i = 0; i< [str length]; i++){
        
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            numbers = numbers + 1;
            stard = i;
        }
    }
    
    NSString *name = [str substringWithRange:NSMakeRange(stard - numbers + 1, numbers )];
    NSString *subStr = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [str stringByReplacingOccurrencesOfString:name withString:subStr];
    
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    //获取请求的绝对路径.
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding];
    
    if ([urlString rangeOfString:@"result"].location != NSNotFound) {
        
        
        if([urlString rangeOfString:@"success"].location != NSNotFound)//_roaldSearchText
        {
            [[Tools shareTools]progressWithTitle:_alterTitle Image:kTimage OnView:self.view Hide:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
       
        }else{
            [HTView alterTitle:[urlString substringFromIndex:7] WithTimer:0];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }

    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    return  YES;
}







@end

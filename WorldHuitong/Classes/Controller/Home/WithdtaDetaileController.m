//
//  WithdtaDetaileController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/27.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "WithdtaDetaileController.h"

@interface WithdtaDetaileController ()
@property(nonatomic,strong)UIWebView *txWebView;

@end

@implementation WithdtaDetaileController

- (void)viewDidLoad {
   
    [super viewDidLoad];

    [self creatWebView];
    
}


#pragma ----UIWebViewDelegate----
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[Tools shareTools]progressWithTitle:@"拼命加载中..." OnView:self.view];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [self.txWebView stringByEvaluatingJavaScriptFromString:@"document.title;"];

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
            [[Tools shareTools]progressWithTitle:@"恭喜您,提现成功" Image:kTimage OnView:self.view Hide:1.5];
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
    self.view.backgroundColor = HT_BG_COLOR;
    _txWebView = [[UIWebView alloc]init];
    _txWebView.frame = CGRectMake(0, -48, kScreenWidth, kScreenHeigth + 148);
    _txWebView.delegate = self;
    _txWebView.scalesPageToFit = YES;
    
    [_txWebView.scrollView setBounces:NO];
    _txWebView.mediaPlaybackAllowsAirPlay = YES;
    _txWebView.mediaPlaybackRequiresUserAction = YES;
  
    NSURL *tixianUrl = [[NSURL alloc]initWithString:[self IsChinese:_url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:tixianUrl];
    [_txWebView loadRequest:request];
    [self.view addSubview:_txWebView];
    
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
//            NSLog(@"stard:%d  numbers:%d",stard,numbers);
        }
    }
    
    NSString *name = [str substringWithRange:NSMakeRange(stard - numbers + 1, numbers )];
    NSString *subStr = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [str stringByReplacingOccurrencesOfString:name withString:subStr];
    
}

@end

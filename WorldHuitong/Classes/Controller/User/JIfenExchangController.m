//
//  JIfenExchangController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//


#import "JIfenExchangController.h"
#import "ShopDetaileHeadCell.h"
#import "OrderFillController.h"
#import "ShopDetaileSeg.h"
#import "Shop.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"

@interface JIfenExchangController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong)UIButton *tempBtn;
@property(nonatomic,strong)Shop *shop;
@property(nonatomic,strong)NSMutableArray *imageList;
@property(nonatomic,strong)NSString *contentType;


/**出现的view**/
@property(nonatomic,strong) UIView *appearView;

/**取消蒙版**/
@property(nonatomic,strong) UIButton *cancel;
@property(nonatomic,strong) UILabel *numberLable;
@property(nonatomic,assign) int number;
@property(nonatomic,assign) BOOL isselected;




@end

@implementation JIfenExchangController

-(UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,self.view.bounds.size.height - 200)];
        _cancel.backgroundColor = [UIColor blackColor];
        [_cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancel.alpha = 0.3;
    }
    return _cancel;
}

-(UIView *)appearView
{
    if (!_appearView) {
        _appearView = [[UIView alloc]init];
        _appearView.backgroundColor = [UIColor whiteColor];
        _appearView.frame = CGRectMake(0,self.view.bounds.size.height- 200, kScreenWidth, 200 - 44);
    
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 20)];
        title.text = @"购买数量";
        title.textAlignment =NSTextAlignmentCenter;
        [_appearView addSubview:title];
        
        UIButton *jian = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 88, 80, 34, 34)];
        [jian addTarget:self action:@selector(jianAction) forControlEvents:UIControlEventTouchUpInside];
        [jian setBackgroundImage:[UIImage imageNamed:@"touzi_jian"] forState:UIControlStateNormal];
        [_appearView addSubview:jian];

        UIButton *jia = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 44, 80, 34, 34)];
        [jia setBackgroundImage:[UIImage imageNamed:@"touzi_add"] forState:UIControlStateNormal];
        [jia addTarget:self action:@selector(jiaAction) forControlEvents:UIControlEventTouchUpInside];
        [_appearView addSubview:jia];
        
        _number = 1;
        _isselected = YES;
        _numberLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 44, 80, 88, 44)];
        _numberLable.text = @"购买数量";
        _numberLable.font = [UIFont systemFontOfSize:24];
        _numberLable.text = [NSString stringWithFormat:@"%d",_number];
        _numberLable.textAlignment =NSTextAlignmentCenter;
        [_appearView addSubview:_numberLable];
        
    
    }
    return _appearView;
}

-(UIWebView *)webView
{
    if (!_webView) {
         _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,self.view.bounds.size.height - 44)];
         _webView.dataDetectorTypes = UIDataDetectorTypeAll;
         _webView.scalesPageToFit = NO;
         _webView.delegate = self;
         _webView.backgroundColor = [UIColor clearColor];
         _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor redColor];
    }
    return _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = HT_BG_COLOR;
    _contentType = @"1";
    [self detaileDate];
}

#pragma ----UITableViewDataSource----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        ShopDetaileHeadCell *cell = [ShopDetaileHeadCell shopDetaileHeadCellWithModle:_shop];
        [self addSdCycleScrollView:cell.shopicon];
        return cell;
    }
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    
    /**添加webView**/
    NSString *str =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *url= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/1.html",str]];
    self.webView.scalesPageToFit = YES;
    NSString *htmlStr = [self flattenHTMLProdc:_shop.shop_description];
    [self.webView loadHTMLString:htmlStr baseURL:url];
    [cell.contentView addSubview:self.webView];
    
    return cell;
}

-(void)addSdCycleScrollView:(UIView *)view
{
    SDCycleScrollView *cycView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 160) delegate:nil placeholderImage:nil];
    cycView.placeholderImage = [UIImage imageNamed:@"bg_baner"];
    cycView.imageURLStringsGroup = self.imageList;
    cycView.currentPageDotColor = HT_COLOR;
    cycView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycView.hidesForSinglePage = YES;
    cycView.autoScrollTimeInterval = 1000;
    cycView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    cycView.pageDotColor = [UIColor whiteColor];
    [view addSubview:cycView];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.view.bounds.size.height - 44;
    }
    return 287;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopDetaileSeg *seg = [[[NSBundle mainBundle]loadNibNamed:@"ShopDetaileSeg" owner:self options:nil] lastObject];
    seg.guigeBtn.selected = YES;
    _tempBtn = seg.guigeBtn;
    [seg.guigeBtn setTitleColor:HT_COLOR forState:UIControlStateSelected];
    [seg.guigeBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [seg.queBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [seg.disBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    return seg;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 38;
}


//详情页数据
-(void)detaileDate
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"module":@"goods",
                          @"q":@"get_one",
                          @"method":@"get",
                          @"goodsnum":_goodsnum,
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        [[Tools shareTools]hidenHud];
//       NSLog(@"%@",response);
        
        self.imageList = [[NSMutableArray alloc]init];
        NSArray *imageList = [response[@"img"] componentsSeparatedByString:@"|"];
        for (NSString *image in imageList) {
            NSString *url = [NSString stringWithFormat:@"%@%@",kBaseImageUrl,image];
            
            [self.imageList addObject:url];
        }
        _shop = [Shop mj_objectWithKeyValues:response];
        [_tableView reloadData];
        
    } fail:^(NSError *error) {
        [[Tools shareTools]hidenHud];
        
    }];


}

//立即抢购
- (IBAction)lijiBuyAction:(id)sender
{
    
    if (_isselected == YES) {
        OrderFillController *order = [[OrderFillController alloc]init];
        order.shop = _shop;
          order.shopNumber =  _number;
        [self.navigationController pushViewController:order animated:YES];
    }else{
        [self.view addSubview:self.appearView];
        [self.view addSubview:self.cancel];
    }

}

//选择内容（规格、描述、问题）
-(void)selectAction:(UIButton*)sender
{
    if(sender != self.tempBtn){
        self.tempBtn.selected = NO;
        self.tempBtn = sender;
    }
    self.tempBtn.selected = YES;

    if (sender.selected) {
        [sender setTitleColor:HT_COLOR forState:UIControlStateSelected];
    }else{
        [sender setTitleColor:RGBA_COLOR(74, 74, 74, 1) forState:UIControlStateNormal];
    }
    
    if (sender.tag == 3001) {
       _contentType = @"1";
        NSString *htmlStr = [self flattenHTMLProdc:_shop.shop_description];
        [self.webView loadHTMLString:htmlStr baseURL:nil];
    }else if (sender.tag == 3002){
        _contentType = @"2";
        NSString *htmlStr = [self flattenHTMLParam:_shop.params];
        [self.webView loadHTMLString:htmlStr baseURL:nil];
    }else if(sender.tag == 3003){
        _contentType = @"3";
        NSString *htmlStr = [self flattenHTMLParam:_shop.question];
        [self.webView loadHTMLString:htmlStr baseURL:nil];
    }
    
    
}

//替换规格参数html标签
-(NSString*)flattenHTMLParam:(NSString*)htmlPara
{
    if (htmlPara) {
        htmlPara = [htmlPara stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/dyupfiles/attached/image"] withString:[NSString stringWithFormat:@"%@%@",kBaseImageUrl,@"/dyupfiles/attached/image"]];
    }
    return [self flattenHTML:htmlPara];
}

//替换商品描述html标签
-(NSString*)flattenHTMLProdc:(NSString*)htmlProdc
{
    if (htmlProdc) {

    htmlProdc = [htmlProdc stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/dyplugins/dykineditor/php/../../../dyupfiles/attached/image"] withString:[NSString stringWithFormat:@"%@%@",kBaseImageUrl,@"/dyupfiles/attached/image"]];
    }
    return [self flattenHTML:htmlProdc];
}

/**
 *  控制webView自适应的代码-js
 */

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *javascript = @"";
    if ([_contentType isEqualToString:@"1"]) {
        javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
                                viewPortTag.id='viewport';  \
                                viewPortTag.name = 'viewport';  \
                                viewPortTag.content = 'width=%d; initial-scale=1.0; maximum-scale=0.4; user-scalable=yes;';  \
                                document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , (int) kScreenWidth];
        
    }else{
        javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
                      viewPortTag.id='viewport';  \
                      viewPortTag.name = 'viewport';  \
                      viewPortTag.content = 'width=%d; initial-scale=1.0; maximum-scale=0.8; user-scalable=yes;';  \
                      document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , (int) kScreenWidth];
    }
    [self.webView stringByEvaluatingJavaScriptFromString:javascript];

}


//检索并替换html标签
-(NSString*)flattenHTML:(NSString*)html
{
    
    NSScanner *theScanner;
    NSString *text = @"&lt";
    NSString *text2 = @"&gt";
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"&lt" intoString:NULL];
        [theScanner scanUpToString:@"&gt" intoString:nil];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",text] withString:@"<"];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",text2] withString:@">"];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&quot"] withString:@"\""];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@";"] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\\"] withString:@""];
    }
    
    
    return html;
    
}


//减
-(void)jianAction
{
    if (_number > 1) {
        _number = _number - 1;
        _numberLable.text = [NSString stringWithFormat:@"%d",_number];
    }
}

//加
-(void)jiaAction
{
    _number++;
    _numberLable.text = [NSString stringWithFormat:@"%d",_number];
}
//取消蒙版
-(void)cancelAction
{
//    _isselected = NO;
    [self.appearView removeFromSuperview];
    [self.cancel removeFromSuperview];
}

@end

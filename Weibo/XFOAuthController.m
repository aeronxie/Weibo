//
//  XFOAuthController.m
//  Weibo
//
//  Created by Fay on 15/9/20.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFOAuthController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "XFAccount.h"
#import "XFTabBarViewController.h"
#import "XFNewFeatureController.h"
#import "XFAccountTool.h"
#import "UIWindow+Extension.h"


@interface XFOAuthController ()<UIWebViewDelegate>

@end
@implementation XFOAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.delegate = self;
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=568898243&redirect_uri=http://www.sharesdk.cn"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    
}

//隐藏状态栏
-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

#pragma mark-webView的代理方法


-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [MBProgressHUD showMessage:@"正在加载..."];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [MBProgressHUD hideHUD];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [MBProgressHUD hideHUD];
    
}





-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //获得Url
    NSString *url = request.URL.absoluteString;
    
    //判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    
    if (range.length != 0) {
        //截取code=后面的参数
        int fromIndex = (int)(range.location + range.length);
        NSString *code = [url substringFromIndex:fromIndex];
    
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];

        //禁止加载回调页面
        return NO;
    }
    
    return YES;
}

/**
 *  利用code（授权成功后的request token）换取一个accessToken
 *
 *  @param code 授权成功后的request token
 */

- (void)accessTokenWithCode:(NSString *)code{
    
/*
    URL:https://api.weibo.com/oauth2/access_token
    HTTP请求方式:POST
 
 请求参数
    client_id	true	string	申请应用时分配的AppKey。
    client_secret	true	string	申请应用时分配的AppSecret。
    grant_type	true	string	请求的类型，填写authorization_code
    grant_type为authorization_code时
    code	true	string	调用authorize获得的code值。
    redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。

    */
    NSString *url = @"https://api.weibo.com/oauth2/access_token";
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"568898243";
    params[@"client_secret"] = @"38a4f8204cc784f81f9f0daaf31e02e3";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"http://www.sharesdk.cn";
    params[@"code"] = code;
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
           [MBProgressHUD hideHUD];
                
        // 将返回的账号字典数据 --> 模型，存进沙盒
        XFAccount *account = [XFAccount accountWithDict:responseObject];
        //储存账号信息
        [XFAccountTool saveAccount:account];
        
        // 切换窗口的根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
    
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"失========败%@",error);
    }];
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

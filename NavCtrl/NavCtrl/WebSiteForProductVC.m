//
//  WebSiteForProductVC.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/11/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "WebSiteForProductVC.h"

@interface WebSiteForProductVC ()

@end

@implementation WebSiteForProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.nsrequest=[NSURLRequest requestWithURL:self.nsurl];
    [self.webView loadRequest:self.nsrequest];
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

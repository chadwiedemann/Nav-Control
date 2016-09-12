//
//  WebSiteForProductVC.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/11/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "WebSiteForProductVC.h"
#import "EditProductVC.h"

@interface WebSiteForProductVC ()
@property (retain, nonatomic) EditProductVC *editVC;

@end

@implementation WebSiteForProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Product Link";
    self.editVC = [[EditProductVC alloc]init];
    self.editVC.webSiteVC = self;
    UIBarButtonItem *editProduct = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editProduct:)];
    self.navigationItem.rightBarButtonItem = editProduct;
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(backToProductList:)];
    [theConfiguration release];
    self.navigationItem.leftBarButtonItem=btn;
}

-(void)editProduct: (id)sender
{
    
    
    self.editVC.productEditing = self.productShown;
    self.editVC.companyFrom = self.companyFrom;
    
    [self.navigationController pushViewController:self.editVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.nsrequest=[NSURLRequest requestWithURL:self.nsurl];
    [self.webView loadRequest:self.nsrequest];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToProductList: sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

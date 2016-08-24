//
//  WebSiteForProductVC.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/11/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Product.h"
#import "Company.h"

@interface WebSiteForProductVC : UIViewController <WKNavigationDelegate>
@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, retain) NSURL *nsurl;
@property (nonatomic, retain) NSURLRequest *nsrequest;
@property (nonatomic, retain) Product *productShown;
@property (nonatomic, retain) Company *companyFrom;
@end

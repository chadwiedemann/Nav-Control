//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebSiteForProductVC.h"
#import "Company.h"


@interface ProductViewController : UITableViewController
@property (nonatomic, retain) WebSiteForProductVC* webSiteVC;
@property (nonatomic, retain) Company* company;

@end

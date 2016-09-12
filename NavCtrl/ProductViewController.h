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
#import "ProductFormVC.h"


@interface ProductViewController : UIViewController <UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, retain) WebSiteForProductVC* webSiteVC;
@property (nonatomic, retain) ProductFormVC* companyForm;
@property (nonatomic, retain) Company* company;
@property (retain, nonatomic) ProductFormVC *productVC;
@property (retain, nonatomic) IBOutlet UITableView *productTableView;


@end

//
//  ProductVController.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 9/7/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
#import "QuartzCore/QuartzCore.h"
#import <UIKit/UIKit.h>
#import "WebSiteForProductVC.h"
#import "Company.h"
#import "AddProductFormVC.h"

@interface ProductVController : UIViewController <UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, retain) WebSiteForProductVC* webSiteVC;
@property (nonatomic, retain) AddProductFormVC* companyForm;
@property (nonatomic, retain) Company* company;
@property (retain, nonatomic) AddProductFormVC *addProductVC;
@property (retain, nonatomic) IBOutlet UITableView *productTableView;
@property (retain, nonatomic) IBOutlet UIImageView *companyImage;
@property (retain, nonatomic) IBOutlet UILabel *companyLabel;
- (IBAction)addProductButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *noProductView;

@end

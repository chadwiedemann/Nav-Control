//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "EditCompanyVC.h"
@class ProductVController;

@interface CompanyViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >


@property (nonatomic, retain) IBOutlet  ProductVController * productViewController;
@property (nonatomic,retain) EditCompanyVC *editCompanyVC;
@property (nonatomic, retain) NSData *JSONData;
@property (nonatomic, retain) NSMutableArray *stockInfoArray;
@property (retain, nonatomic) IBOutlet UITableView *companyTableView;
- (IBAction)undoButton:(id)sender;
- (IBAction)redoButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *noCompaniesImageView;
- (IBAction)addCompanyButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *noCompaniesView;
@property NSTimer *stockPriceReloadTimer;
@end

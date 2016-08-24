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
@class ProductViewController;

@interface CompanyViewController : UITableViewController


@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;
@property (nonatomic,retain) EditCompanyVC *editCompanyVC;
@property (nonatomic, retain) NSData *JSONData;
@property (nonatomic, retain) NSMutableArray *stockInfoArray;


@end

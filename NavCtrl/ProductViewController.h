//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebSiteForProductVC.h"


@interface ProductViewController : UITableViewController
@property (nonatomic, retain) WebSiteForProductVC* webSiteVC;
@property (nonatomic, retain) NSMutableArray *appleProducts;
@property (nonatomic, retain) NSMutableArray *appleProductImages;
@property (nonatomic, retain) NSMutableArray *samsungProducts;
@property (nonatomic, retain) NSMutableArray *samsungProductImages;
@property (nonatomic, retain) NSMutableArray *blackberryProducts;
@property (nonatomic, retain) NSMutableArray *blackberryProductImages;
@property (nonatomic, retain) NSMutableArray *HTCProducts;
@property (nonatomic, retain) NSMutableArray *HTCProductImages;





@property (nonatomic, retain) NSArray *productURL;
@property (nonatomic, retain) NSDictionary *productURLDictionary;

@end

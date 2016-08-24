//
//  EditProductVC.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/22/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "Company.h"
#import "WebSiteForProductVC.h"

@interface EditProductVC : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;

@property (retain, nonatomic) IBOutlet UITextField *productURL;
@property (retain, nonatomic) IBOutlet UITextField *productImageURL;
@property (retain, nonatomic) Product *productEditing;
@property (retain, nonatomic) Company *companyFrom;
@property (retain, nonatomic) WebSiteForProductVC *webSiteVC;
- (IBAction)deleteProduct:(id)sender;


@end

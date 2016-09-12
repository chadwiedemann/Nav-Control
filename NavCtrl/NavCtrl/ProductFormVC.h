//
//  ProductFormVC.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/17/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@interface AddProductFormVC : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *productTextField;
@property (retain, nonatomic) IBOutlet UITextField *logoImageTextField;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField;
- (IBAction)saveProductButton:(UIBarButtonItem *)sender;
@property (nonatomic, retain) Company *curentCompany;
- (IBAction)backToProductButton:(id)sender;
@property (retain, nonatomic) IBOutlet UINavigationItem *backToProductImage;


@end

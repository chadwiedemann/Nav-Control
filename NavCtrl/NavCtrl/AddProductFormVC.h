//
//  AddProductFormVC.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 9/8/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
#import "Company.h"
#import <UIKit/UIKit.h>

@interface AddProductFormVC : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *productTextField;
@property (retain, nonatomic) IBOutlet UITextField *logoImageTextField;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField;

@property (nonatomic, retain) Company *curentCompany;


@end

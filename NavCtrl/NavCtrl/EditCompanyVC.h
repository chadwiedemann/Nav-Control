//
//  EditCompanyVC.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/23/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import <UIKit/UIKit.h>
#import "Company.h"

@interface EditCompanyVC : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *companyName;
@property (retain, nonatomic) IBOutlet UITextField *companyTicker;
@property (retain, nonatomic) IBOutlet UITextField *companyLogo;
@property (retain, nonatomic) Company *editingCompany;
- (IBAction)deleteCompanyButton:(id)sender;

@end

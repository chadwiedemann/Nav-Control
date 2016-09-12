//
//  CompanyForm.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyForm : UIViewController
- (IBAction)saveCompanyData:(UIBarButtonItem *)sender;
@property (retain, nonatomic) IBOutlet UITextField *CompanyTextField;
@property (retain, nonatomic) IBOutlet UITextField *companyLogoTextField;
@property (retain, nonatomic) IBOutlet UITextField *companyTicker;
@property int companyID;
- (IBAction)cancelButton:(id)sender;


@end

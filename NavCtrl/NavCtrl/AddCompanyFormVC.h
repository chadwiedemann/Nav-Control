//
//  AddCompanyFormVC.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 9/8/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import <UIKit/UIKit.h>

@interface AddCompanyFormVC : UIViewController


@property (retain, nonatomic) IBOutlet UITextField *CompanyTextField;
@property (retain, nonatomic) IBOutlet UITextField *companyLogoTextField;
@property (retain, nonatomic) IBOutlet UITextField *companyTicker;
@property int companyID;



@end

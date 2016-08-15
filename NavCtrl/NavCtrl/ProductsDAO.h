//
//  ProductsDAO.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductsDAO : NSObject

-(NSArray *) retrieveCompanies;
-(NSArray *) retrieveCompanyProduct:(NSString *) companyApple;


@end

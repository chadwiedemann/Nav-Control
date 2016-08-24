//
//  DAO.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import "Product.h"

@interface DAO : NSObject


@property (nonatomic, retain) NSMutableArray *companyList;


+ (DAO*)sharedInstanceOfDAO;
-(void)addCompany: (Company *) company;
-(void)deleteCompany: (Company *) company;
-(void)addProductToCompany: (NSString *)company product:(Product*) product;
-(void)removeProductFromCompany: (NSString *)company product:(Product*) product;

@end

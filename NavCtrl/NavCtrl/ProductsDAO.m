//
//  ProductsDAO.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ProductsDAO.h"
#import "Product.h"
#import "Company.h"

@interface ProductsDAO()
{
    NSMutableArray *_companies;
}

@end

@implementation ProductsDAO

-(id) init{
    self = [super init];
    if(self){
        _companies = [[NSMutableArray alloc]init];
        Company *appleCompany = [[Company alloc]init];
        appleCompany.name = @"Apple mobile devices";
        appleCompany.logo= @"apple";
        Product *product1 = [[Product alloc]init];
        product1.name = @"iPhone";
        product1.url = @"http://www.apple.com/iphone/";
        [appleCompany.products addObject:product1];
        
        [_companies addObject:appleCompany];
        
    }
    return self;
}


-(NSArray*) retrieveCompanies{
    return _companies;
}

@end

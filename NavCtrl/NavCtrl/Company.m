//
//  Company.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithCompanyName: (NSString*) name logo: (NSString*) logo
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.logoString = logo;
        self.productsSold = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)addProduct: (Product*) product
{
    if(self.productsSold==nil){
        self.productsSold = [[NSMutableArray alloc]init];
    }
    [self.productsSold addObject:product];
}
@end

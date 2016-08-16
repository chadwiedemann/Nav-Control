//
//  Company.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Company : NSObject

@property int companyId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *logoString;
@property (nonatomic, retain) NSMutableArray *productsSold;

-(instancetype)initWithCompanyName: (NSString*) name logo: (NSString*) logo;
-(void)addProduct:(Product*) product;



@end

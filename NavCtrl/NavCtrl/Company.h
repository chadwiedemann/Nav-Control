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


@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *logoString;
@property (nonatomic, retain) NSString *logoURL;
@property (nonatomic, retain) NSString *ticker;
@property float currentStockPrice;
@property (nonatomic, retain) NSMutableArray *productsSold;
@property NSInteger companyID;

-(instancetype)initWithCompanyName:(NSString*)name
                              logo:(NSString*)logo;

-(instancetype)initWithCompanyName:(NSString*)name
                           logoURL:(NSString *)logoURL
                            ticker:(NSString*)ticker;

-(void)addProduct:(Product*) product;



@end

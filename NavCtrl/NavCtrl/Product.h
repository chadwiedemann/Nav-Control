//
//  Product.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *imageString;
@property (nonatomic, retain) NSString *imageURL;
@property NSInteger companyID;
@property NSInteger productID;



-(instancetype)initWithProductName:(NSString*)name
                               url:(NSString*)url
                       imageString:(NSString*)imageString
                           company:(int)companyID;

-(instancetype)initWithProductName:(NSString*)name
                               url:(NSString*)url
                          imageURL:(NSString*)imageURL
                           company:(int)companyID;



@end

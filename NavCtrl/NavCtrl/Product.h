//
//  Product.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *imageString;
@property (nonatomic, retain) NSString *imageURL;
@property NSInteger productIdentifier;



-(instancetype)initWithProductName: (NSString*) name url: (NSString*) url imageString: (NSString*) imageString;
-(instancetype)initWithProductName: (NSString*) name url: (NSString*) url imageURL: (NSString*) imageURL;



@end

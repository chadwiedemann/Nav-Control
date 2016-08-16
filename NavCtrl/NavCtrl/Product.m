//
//  Product.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product

-(instancetype)initWithProductName: (NSString*) name url: (NSString*) url imageString: (NSString*) imageString
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.urlString = url;
        self.imageString = imageString;
    }
    return self;
}


@end

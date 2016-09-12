//
//  ProductMO+CoreDataProperties.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 9/1/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProductMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) NSString *imageString;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *urlString;
@property (nullable, nonatomic, retain) NSNumber *productID;
@property (nullable, nonatomic, retain) CompanyMO *company;

@end

NS_ASSUME_NONNULL_END

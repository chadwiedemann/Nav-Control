//
//  CompanyMO+CoreDataProperties.h
//  NavCtrl
//
//  Created by Chad Wiedemann on 9/1/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompanyMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) NSString *logoString;
@property (nullable, nonatomic, retain) NSString *logoURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *ticker;
@property (nullable, nonatomic, retain) NSSet<ProductMO *> *products;

@end

@interface CompanyMO (CoreDataGeneratedAccessors)

- (void)addProductsObject:(ProductMO *)value;
- (void)removeProductsObject:(ProductMO *)value;
- (void)addProducts:(NSSet<ProductMO *> *)values;
- (void)removeProducts:(NSSet<ProductMO *> *)values;

@end

NS_ASSUME_NONNULL_END

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
#import <CoreData/CoreData.h>
#import "CompanyMO.h"

@interface DAO : NSObject


@property (nonatomic, retain) NSMutableArray<Company*> *companyList;
@property (nonatomic, retain) NSMutableArray<CompanyMO*> *companyMO;
@property (nonatomic, retain) NSMutableArray<ProductMO*> *productMO;

+ (DAO*)sharedInstanceOfDAO;
-(void)addCompany: (Company *) company;
-(void)deleteCompany: (Company *) company;
-(void)addProductToCompany: (NSString *)company product:(Product*) product;
-(void)removeProductFromCompany: (Company *)company product:(Product*) product;
-(Company *)findCompanyByTicker: (NSString *)ticker;
-(void)editCompanyInfo:(Company*)company name:(NSString*)name ticker:(NSString*)ticker logoURL:(NSString*)logoURL;
-(void)editProductInfo:(NSString*)name productURL:(NSString*)productURL productImageURL:(NSString*)productImageURL productEditing:(Product*)product companyFrom:(Company*)company;
-(void)undoMethod;
-(void)redoMethod;
-(void) reloadDataFromContext;


//core data setup
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

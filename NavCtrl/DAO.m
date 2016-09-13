//
//  DAO.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DAO.h"
#import "Company.h"
#import "Product.h"
#import "CompanyMO.h"
#import "CompanyMO+CoreDataProperties.h"
#import "NavControllerAppDelegate.h"
#import "ProductMO+CoreDataProperties.h"
#import <objc/message.h>

@implementation DAO

-(id)init
{
    self = [super init];
    if(self)
    {
    
        self.companyList = [[NSMutableArray alloc]init];

        //fetch companies
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSSortDescriptor *sortByCreationDate = [[NSSortDescriptor alloc]
                                                initWithKey:@"companyID" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByCreationDate]];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyMO" inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        NSArray *fetchedCompanies = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
 
        
        
        
        if (fetchedCompanies == nil) {
            NSLog(@"%@",error.localizedDescription);
        }
        self.companyMO = [fetchedCompanies mutableCopy];
        
       
        
      
        
        //fetch products
        NSFetchRequest *fetchedProducts = [[NSFetchRequest alloc] init];
        NSSortDescriptor *sortByCreationDateProducts = [[NSSortDescriptor alloc]
                                                initWithKey:@"productID" ascending:YES];
        [fetchedProducts setSortDescriptors:[NSArray arrayWithObject:sortByCreationDateProducts]];
        NSEntityDescription *entityProducts = [NSEntityDescription entityForName:@"ProductMO" inManagedObjectContext:[self managedObjectContext]];
        [fetchedProducts setEntity:entityProducts];
        NSError *errorProducts = nil;
        NSArray *fetchedObjectsProducts = [[self managedObjectContext] executeFetchRequest:fetchedProducts error:&error];
        if (fetchedObjectsProducts == nil) {
            NSLog(@"%@",errorProducts.localizedDescription);
        }
        self.productMO = [fetchedObjectsProducts mutableCopy];
        self.managedObjectContext.undoManager = [[NSUndoManager alloc]init];
        
        
        
        [sortByCreationDate release];
        [sortByCreationDateProducts release];
        //[sortByCreationDateProducts dealloc];
        //[sortByCreationDate dealloc];
        [fetchRequest release];
        [fetchedProducts release];
        
        
      
     //   return self;
        
        
        
        

        //creating hardcoded data
        if(fetchedCompanies.count == 0){
            NSLog(@"empty database");
            
            Company *apple = [[Company alloc]initWithCompanyName:@"Apple Inc." logo:@"apple"];
            apple.ticker=@"AAPL";
            
            CompanyMO *appleMO = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:[self managedObjectContext]];
            appleMO.name = apple.name;
            appleMO.logoString = apple.logoString;
            appleMO.ticker = apple.ticker;
            appleMO.companyID = [NSNumber numberWithInteger:apple.companyID];
            
            Company *google = [[Company alloc]initWithCompanyName:@"Google" logo:@"google"];
            google.ticker = @"GOOG";
            
            CompanyMO *googleMO = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:[self managedObjectContext]];
            googleMO.name = google.name;
            googleMO.logoString = google.logoString;
            googleMO.ticker = google.ticker;
            googleMO.companyID = [NSNumber numberWithLong:google.companyID];
            
            Company *twitter = [[Company alloc]initWithCompanyName:@"Twitter" logo:@"twitter"];
            twitter.ticker = @"TWTR";
            
            CompanyMO *twitterMO = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:[self managedObjectContext]];
            twitterMO.name = twitter.name;
            twitterMO.logoString = twitter.logoString;
            twitterMO.ticker = twitter.ticker;
            twitterMO.companyID = [NSNumber numberWithInteger:twitter.companyID];
            
            Company *tesla = [[Company alloc]initWithCompanyName:@"Tesla" logo:@"tesla"];
            tesla.ticker = @"TSLA";
            
            CompanyMO *teslaMO = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:[self managedObjectContext]];
            teslaMO.name = tesla.name;
            teslaMO.logoString = tesla.logoString;
            teslaMO.ticker = tesla.ticker;
            teslaMO.companyID = [NSNumber numberWithInteger:tesla.companyID];
            
            Product *macBook = [[Product alloc]initWithProductName:@"MacBook - Space Gray" url:@"http://www.apple.com/macbook-pro/" imageString:@"macbook" company:apple.companyID];
            
            ProductMO *macBookMO = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:[self managedObjectContext]];
            macBookMO.name = macBook.name;
            macBookMO.urlString = macBook.urlString;
            macBookMO.imageString = macBook.imageString;
            macBookMO.companyID = [NSNumber numberWithInteger:macBook.companyID];
            macBookMO.company = appleMO;
            macBookMO.productID = [NSNumber numberWithInteger:macBook.productID];
            [self.productMO addObject:macBookMO];
            [apple addProduct:macBook];
            
            [self.companyList addObject:apple];
            [self.companyMO addObject:appleMO];
            [self.companyList addObject:tesla];
            [self.companyList addObject:twitter];
            [self.companyList addObject:google];
            [self.companyMO addObject:teslaMO];
            [self.companyMO addObject:googleMO];
            [self.companyMO addObject:twitterMO];
            [self saveContext];
            
        }else
        {
            NSLog(@"we have data");
            for(CompanyMO *comp in self.companyMO)
            {
                [self createCompanyFromMO:comp products:self.productMO];
            }
        }
        
        
    }
    
        
    return self;
}

-(void)addMOProduct:(ProductMO*)productMO toCompanyMO:(CompanyMO*)companyMO
{
    NSMutableArray *ProductArray = [NSMutableArray arrayWithArray:[companyMO.products allObjects]];
    [ProductArray addObject:productMO];
    NSSet *appleSet = [[NSSet alloc]initWithArray:ProductArray];
    companyMO.products = appleSet;
}


-(void)createCompanyFromMO:(CompanyMO*)companyMO
{
    Company *comp = [[Company alloc]initWithCompanyName:companyMO.name logo:companyMO.logoString];
    comp.ticker = companyMO.ticker;
    comp.logoURL = companyMO.logoURL;
    comp.companyID = companyMO.companyID;
    [self.companyList addObject:comp];
}

-(void)createCompanyFromMO:(CompanyMO*)companyMO products:(NSArray*)products
{
    Company *comp = [[Company alloc]initWithCompanyName:companyMO.name logo:companyMO.logoString];
    comp.ticker = companyMO.ticker;
    comp.logoURL = companyMO.logoURL;
    comp.companyID = [companyMO.companyID integerValue];
    comp.productsSold = [[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:comp.logoURL];
    NSURLSessionDownloadTask *downloadLogoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
        UIImage *downloadedLogo = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        if(downloadedLogo != nil)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString * filename = [NSString stringWithFormat:@"%@.jpg", companyMO.name];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
            comp.logoURL = path;
            NSData *data = UIImagePNGRepresentation(downloadedLogo);
            [data writeToFile:path atomically:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"newCompanyImageDownloaded"
             object:nil];
        });
    }];
    [downloadLogoTask resume];
 
    
    
    for(ProductMO *prod in products)
    {
        if([prod.company isEqual:companyMO])
        {
            Product *product = [self createProductFromMOProduct:prod];
            if(comp.productsSold==nil){
                comp.productsSold = [[NSMutableArray alloc]init];
            }
            [comp.productsSold addObject:product];
        }
    }
    
    
    
    [self.companyList addObject:comp];
    
}

-(Product*)createProductFromMOProduct: (ProductMO*)productMO
{
    Product *product = [[Product alloc]initWithProductName:productMO.name url:productMO.urlString imageURL:productMO.imageURL company:[NSNumber numberWithInteger:productMO.companyID]];
    product.imageString=productMO.imageString;
    product.productID = [productMO.productID integerValue];
//    [product autorelease];
    return product;
}

+ (DAO*)sharedInstanceOfDAO
{
    // 1
    static DAO *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DAO alloc] init];
    });
    return _sharedInstance;
}

-(void)addCompany: (Company *) company
{
    if(self.companyList==nil)
    {
        self.companyList=[[NSMutableArray alloc]init];
    }
    [self.companyList addObject:company];
    
    CompanyMO *newCompanyMO = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:[self managedObjectContext]];
    
    newCompanyMO.name = company.name;
    newCompanyMO.ticker = company.ticker;
    newCompanyMO.logoURL = company.logoURL;
    newCompanyMO.logoString = company.logoString;
    newCompanyMO.companyID = [NSNumber numberWithInteger:company.companyID];
    [self addCompanytoMOArray:newCompanyMO];
//    [self saveContext];
    
    
}

-(void)addCompanytoMOArray: (CompanyMO *) savedCompany
{
    [self.companyMO addObject:savedCompany];
}

-(void)addProductToCompany:(Company*) company product:(Product*) product
{
    
    for(Company *company1 in self.companyList)
    {
        if ([company1 isEqual: company]) {
            if(company1.productsSold){
            [company1.productsSold addObject:product];
            }else{
//                company1.productsSold = [[NSMutableArray alloc]init];
                [company1.productsSold addObject:product];
            }
        }
    }
    
    ProductMO *newProductMO = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:[self managedObjectContext]];
    
    newProductMO.companyID = [NSNumber numberWithInteger:product.companyID];
    newProductMO.imageURL = product.imageURL;
    newProductMO.name = product.name;
    newProductMO.urlString = product.urlString;
    newProductMO.productID = [NSNumber numberWithInteger:product.productID];
    newProductMO.company = [self findCompanyMOforAddingProduct:product.companyID];
    [self.productMO addObject:newProductMO];
//    [self saveContext];
}

-(CompanyMO*)findCompanyMOforAddingProduct: (NSInteger) companyID
{
    for(CompanyMO *c in self.companyMO)
    {
        if(companyID == [c.companyID integerValue])
        {
            return c;
        }
    }
    NSLog(@"error company not found for product");
    return nil;
}


-(void)removeProductFromCompany: (Company *)company product:(Product*) product
{
    for(Company *company1 in self.companyList)
    {
        if([company1 isEqual:company]){
            [company1.productsSold removeObject:product];
        }
    }
    
    for(CompanyMO *c in self.companyMO)
    {
        if(company.companyID == [c.companyID integerValue])
        {
            for(ProductMO *p in c.products)
            {
                if(product.productID == [p.productID integerValue])
                {
                    NSManagedObject *managedObectToDelete = p;
                    [self.managedObjectContext deleteObject:managedObectToDelete];
                    break;
                }
        
            }
        }
    }
//    [self saveContext];
}

-(void)editProductFromCompany: (Company *)company product:(Product*) product
{
    for(Company *company1 in self.companyList)
    {
        if(company1.companyID==company.companyID){
            for(NSUInteger i=0;i<[company1.productsSold count];i++)
            {
                if([[company1.productsSold objectAtIndex:i] name] == product.name){
                    [company1.productsSold setObject:product atIndexedSubscript:i];
                    break;
                }
            }
        }
    }
}

-(void)deleteCompany: (Company *) company
{
    for(NSInteger i=0;i<[self.companyList count];i++)
    {
        if(company.companyID == [[self.companyList objectAtIndex:i] companyID])
        {
            [self.companyList removeObjectAtIndex:i];
            
            break;
        }
    }
    
    for(NSInteger i=0;i<[self.companyMO count];i++)
    {
        long int a = [[[self.companyMO objectAtIndex:i] companyID] integerValue];
        
        if(company.companyID == a)
        {
            
            NSManagedObject *managedObectToDelete = self.companyMO[i];
            [self.managedObjectContext deleteObject:managedObectToDelete];
            break;
        }
    }
//    [company release];
//    [self saveContext];
}

-(void)editCompanyInfo:(Company*)company name:(NSString*)name ticker:(NSString*)ticker logoURL:(NSString*)logoURL
{
    for(CompanyMO *c in self.companyMO)
    {
        if(company.companyID == [c.companyID integerValue])
        {
            if(![ticker isEqual:@""]){
                NSString *uppercaseTicker = [ticker uppercaseString];
                c.ticker = uppercaseTicker;
            }
            if(![name isEqual:@""]){
                c.name = name;
            }
            if (![logoURL isEqual:@""]) {
                c.logoURL = logoURL;
                c.logoString = nil;
            }
        }
    }
//[self saveContext];
}

-(void)editProductInfo:(NSString*)name productURL:(NSString*)productURL productImageURL:(NSString*)productImageURL productEditing:(Product*)product companyFrom:(Company*)company
{
    for(ProductMO *p in self.productMO)
    {
        if(product.productID == [p.productID integerValue])
        {
            if(![name isEqual:@""]){
                p.name = name;
            }
            if(![productURL isEqual:@""]){
                p.urlString = productURL;
            }
            if (![productImageURL isEqual:@""]) {
                p.imageURL = productImageURL;
            }
            p.imageString = nil;
        }
    }
//[self saveContext];
}

-(Company *)findCompanyByTicker: (NSString *)ticker
{
    for (Company *company in self.companyList){
        if ([company.ticker isEqualToString:ticker]){
            return company;
        }
    }
    return nil;
}

-(void)undoMethod
{
    
    [self.managedObjectContext undo];
    [self reloadDataFromContext];
}

-(void)redoMethod
{
    
    [self.managedObjectContext redo];
    [self reloadDataFromContext];
    
}

-(void) reloadDataFromContext
{
   
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSSortDescriptor *sortByCreationDate = [[NSSortDescriptor alloc]
                                    initWithKey:@"companyID" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortByCreationDate]];
    
    NSEntityDescription *e = [[[self managedObjectModel] entitiesByName] objectForKey:@"CompanyMO"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    [sortByCreationDate release];
    [sortByCreationDate dealloc];
 
    
    [self.companyMO setArray:result];

    
    
    //releasing unused objects products and companies
    for(int i = 0;i<[self.companyList count];i++)
    {
        
        for(Product *p in self.companyList[i].productsSold){
            [p autorelease];
            [p autorelease];
            
        }
//        [self.companyList[i].productsSold release];
//        self.companyList[i].productsSold = nil;
//        [self.companyList[i].productsSold dealloc];
        
//        [self.companyList[i].productsSold autorelease];
//        [self.companyList[i].productsSold removeAllObjects];
        [self.companyList[i] autorelease];
    }
    
    [self.companyList removeAllObjects];
    
    
    
    
    
    for(CompanyMO *comp in self.companyMO)
    {
        [self createCompanyFromMO:comp products:self.productMO];
    }
    
}

//-(void)addProduct: (Product*) product
//{
//    if(self.productsSold==nil){
//        self.productsSold = [[NSMutableArray alloc]init];
//    }
//    [self.productsSold addObject:product];
//    [self.productsSold autorelease];
//}



#pragma mark - Core Data stack
                               
    @synthesize managedObjectContext = _managedObjectContext;
    @synthesize managedObjectModel = _managedObjectModel;
    @synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

    - (NSURL *)applicationDocumentsDirectory {
       // The directory the application uses to store the Core Data store file. This code uses a directory named "turntotech.io.core_data_example" in the application's documents directory.
       return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }

    - (NSManagedObjectModel *)managedObjectModel {
       // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
       if (_managedObjectModel != nil) {
           return _managedObjectModel;
       }
       NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NavCtrl" withExtension:@"momd"];
       _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
       return _managedObjectModel;
    }

    - (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
       // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
       if (_persistentStoreCoordinator != nil) {
           return _persistentStoreCoordinator;
       }
       
       // Create the coordinator and store
       
       _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
       NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NavCtrl.sqlite"];
        NSLog(@"%@",storeURL);
        NSError *error = nil;
       NSString *failureReason = @"There was an error creating or loading the application's saved data.";
       if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
           // Report any error we got.
           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
           dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
           dict[NSLocalizedFailureReasonErrorKey] = failureReason;
           dict[NSUnderlyingErrorKey] = error;
           error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
           // Replace this with code to handle the error appropriately.
           // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
           NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
           abort();
       }
       
       return _persistentStoreCoordinator;
    }


    - (NSManagedObjectContext *)managedObjectContext {
       // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
       if (_managedObjectContext != nil) {
           return _managedObjectContext;
       }
       
       NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
       if (!coordinator) {
           return nil;
       }
       _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
       [_managedObjectContext setPersistentStoreCoordinator:coordinator];
       return _managedObjectContext;
    }

#pragma mark - Core Data Saving support
                               
    - (void)saveContext {
       NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
       if (managedObjectContext != nil) {
           NSError *error = nil;
           if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
               // Replace this implementation with code to handle the error appropriately.
               // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
               abort();
           }
       }
    }




@end

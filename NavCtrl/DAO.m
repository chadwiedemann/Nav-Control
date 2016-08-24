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

@implementation DAO

-(id)init
{
    self = [super init];
    if(self)
    {
        Company *apple = [[Company alloc]initWithCompanyName:@"Apple mobile devices" logo:@"apple"];
        apple.ticker=@"AAPL";
        Company *samsung = [[Company alloc]initWithCompanyName:@"Samsung mobile devices" logo:@"samsung"];
        samsung.ticker=@"SSNLF";

        Company *htc = [[Company alloc]initWithCompanyName:@"HTC mobile devices" logo:@"htc"];
        htc.ticker=@"HTC";

        Company *blackberry = [[Company alloc]initWithCompanyName:@"BlackBerry Mobile devices" logo:@"blackberry"];
        blackberry.ticker=@"BBRY";

        Product *iPhone = [[Product alloc]initWithProductName:@"iPhone" url:@"http://www.apple.com/iphone/" imageString:@"iPhone"];
        Product *iPad = [[Product alloc]initWithProductName:@"iPad" url:@"http://www.apple.com/ipad/" imageString:@"iPad"];
        Product *iPod = [[Product alloc]initWithProductName:@"iPod" url:@"http://www.apple.com/ipod/" imageString:@"iPod"];
        Product *galaxyS4 = [[Product alloc]initWithProductName:@"S4" url:@"http://www.samsung.com/us/mobile/phones/galaxy-s/samsung-galaxy-s4-verizon-white-frost-16gb-sch-i545zwavzw/" imageString:@"S4"];
        Product *galaxyNote = [[Product alloc]initWithProductName:@"Note" url:@"http://www.samsung.com/us/explore/galaxy-note-7-features-and-specs/?cid=ppc-" imageString:@"Note"];
        Product *galaxyTab = [[Product alloc]initWithProductName:@"Tab" url:@"http://www.samsung.com/us/explore/tab-s2-features-and-specs/?cid=ppc-" imageString:@"Tab"];
        Product *oneM9 = [[Product alloc]initWithProductName:@"One M9" url:@"http://www.htc.com/us/smartphones/htc-one-m9/" imageString:@"onem9.jpeg"];
        Product *desire626 = [[Product alloc]initWithProductName:@"Desire 626" url:@"http://www.htc.com/us/smartphones/htc-desire-626/" imageString:@"desire626.png"];
        Product *desireEYE = [[Product alloc]initWithProductName:@"Desire EYE" url:@"http://www.htc.com/us/smartphones/htc-desire-eye/" imageString:@"desireeye.png"];
        Product *passport = [[Product alloc]initWithProductName:@"Passport" url:@"http://us.blackberry.com/smartphones/blackberry-passport/overview.html" imageString:@"passport.jpeg"];
        Product *classic = [[Product alloc]initWithProductName:@"Classic" url:@"http://us.blackberry.com/smartphones/blackberry-classic/overview.html" imageString:@"classic.png"];
        Product *LEAP = [[Product alloc]initWithProductName:@"LEAP" url:@"http://us.blackberry.com/smartphones/blackberry-leap/overview.html" imageString:@"LEAP.jpeg"];
        [apple addProduct:iPad];
        [apple addProduct:iPod];
        [apple addProduct:iPhone];
        [samsung addProduct:galaxyS4];
        [samsung addProduct:galaxyTab];
        [samsung addProduct:galaxyNote];
        [htc addProduct:oneM9];
        [htc addProduct:desire626];
        [htc addProduct:desireEYE];
        [blackberry addProduct:passport];
        [blackberry addProduct:classic];
        [blackberry addProduct:LEAP];
        //Adds companies to NSMutableArray
        self.companyList = [[NSMutableArray alloc]init];
        [self.companyList addObject:apple];
        [self.companyList addObject:samsung];
        [self.companyList addObject:htc];
        [self.companyList addObject:blackberry];
    }
    return self;
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
}

-(void)addProductToCompany: (NSString *)company product:(Product*) product
{
    
    for(Company *company1 in self.companyList)
    {
        if ([company1.name isEqual: company]) {
            [company1.productsSold addObject:product];
        }
    }
}

-(void)removeProductFromCompany: (NSString *)company product:(Product*) product
{
    for(Company *company1 in self.companyList)
    {
        if(company1.name==company){
            [company1.productsSold removeObject:product];
        }
    }
}

-(void)editProductFromCompany: (NSString *)company product:(Product*) product
{
    for(Company *company1 in self.companyList)
    {
        if(company1.name==company){
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
        if(company.name == [[self.companyList objectAtIndex:i] name])
        {
            [self.companyList removeObjectAtIndex:i];
            break;
        }
    }
}

-(Company *)findCompanyByTicker: (NSString *)ticker
{
    for (Company *company in self.companyList){
        if ([company.ticker isEqualToString:ticker]){
            return company;
        }
    }
    /*for(NSInteger i=0;i<[self.companyList count];i++)
    {
        if([[[self.companyList objectAtIndex:i] name] isEqualToString:name] )
        {
            return [self.companyList objectAtIndex:i];
        }
    }*/
    return nil;
}

@end

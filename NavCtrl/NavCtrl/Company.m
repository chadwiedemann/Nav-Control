//
//  Company.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithCompanyName: (NSString*) name logo: (NSString*) logo
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.logoString = logo;
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults integerForKey:@"companyID"]){
            [defaults setInteger:1 forKey:@"companyID"];
            self.companyID = 1;
        }else{
            self.companyID = [defaults integerForKey:@"companyID"]+1;
            [defaults setInteger:self.companyID forKey:@"companyID"];
        }
    }
    return self;
}

-(instancetype)initWithCompanyName: (NSString*)name logoURL:(NSString *) logoURL ticker:(NSString *)ticker
{
    self = [super init];
    if(self)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults integerForKey:@"companyID"]){
            [defaults setInteger:1 forKey:@"companyID"];
            self.companyID = 1;
        }else{
            self.companyID = [defaults integerForKey:@"companyID"]+1;
            [defaults setInteger:self.companyID forKey:@"companyID"];
        }
        self.name = name;
//        self.productsSold = [[NSMutableArray alloc]init];
        NSString *uppercaseTicker = [ticker uppercaseString];
        self.ticker = uppercaseTicker;
        self.logoURL = logoURL;
        NSURL *url = [NSURL URLWithString:logoURL];
        NSURLSessionDownloadTask *downloadLogoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
            UIImage *downloadedLogo = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if(downloadedLogo != nil)
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString * filename = [NSString stringWithFormat:@"%@.jpg", name];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
                self.logoURL = path;
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
    }
    return self;
}

-(void)dealloc
{
    [_productsSold release];
    [super dealloc];
}
-(void)addProduct: (Product*) product
{
    if(self.productsSold==nil){
        self.productsSold = [[NSMutableArray alloc]init];
    }
    [self.productsSold addObject:product];
    [self.productsSold autorelease];
}
@end

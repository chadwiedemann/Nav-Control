//
//  Product.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/13/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product



-(instancetype)initWithProductName: (NSString*) name url: (NSString*) url imageString: (NSString*) imageString company:(int)companyID
{
    self = [super init];
    if(self)
    {
        _name = [name retain];
        _urlString = [url retain];
        _imageString = [imageString retain];
        _companyID = companyID;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults integerForKey:@"productID"]){
            [defaults setInteger:1 forKey:@"productID"];
            _productID = 1;
        }else{
            _productID = [defaults integerForKey:@"productID"]+1;
            [defaults setInteger:self.productID forKey:@"productID"];
        }
    
    }
    return self;
}

-(instancetype)initWithProductName: (NSString*) name url: (NSString*) url imageURL: (NSString*) imageURL company:(int)companyID
{
    self = [super init];
    if(self)
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults integerForKey:@"productID"]){
            [defaults setInteger:1 forKey:@"productID"];
            _productID = 1;
        }else{
            _productID = [defaults integerForKey:@"productID"]+1;
            [defaults setInteger:self.productID forKey:@"productID"];
        }
        
        _name = [name retain];
        _urlString = [url retain];
        _companyID = companyID;
        _imageURL = [imageURL retain];
        NSURL *url1 = [NSURL URLWithString:imageURL];
        NSURLSessionDownloadTask *downloadLogoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url1 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *filename = [NSString stringWithFormat:@"%@.jpg", name];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
                self.imageURL = [path retain];
                [[NSFileManager defaultManager] moveItemAtPath:location toPath:path error:&error];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"newProductImageDownloaded"
                     object:nil];
                });
            }
        }];
        [downloadLogoTask resume];
        
   
    }
    
    return self;
}



@end

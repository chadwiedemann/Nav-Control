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

-(instancetype)initWithProductName: (NSString*) name url: (NSString*) url imageURL: (NSString*) imageURL
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.urlString = url;
        NSURL *url1 = [NSURL URLWithString:imageURL];
        NSURLSessionDownloadTask *downloadLogoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url1 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *filename = [NSString stringWithFormat:@"%@.jpg", name];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
                self.imageURL = path;
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

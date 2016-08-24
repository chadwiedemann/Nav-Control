//
//  EditCompanyVC.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/23/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditCompanyVC.h"
#import "CompanyViewController.h"
#import "DAO.h"

@interface EditCompanyVC ()

@end

@implementation EditCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Edit Company";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCompany:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

-(void)saveCompany:sender
{
    if(![self.companyTicker.text isEqual:@""]){
        self.editingCompany.ticker = self.companyTicker.text;
    }
    if(![self.companyName.text isEqual:@""]){
        self.editingCompany.name = self.companyName.text;
    }
    if (![self.companyLogo.text isEqual:@""]) {
         self.editingCompany.logoURL = self.companyLogo.text;
        NSURL *url = [NSURL URLWithString:self.companyLogo.text];
        NSURLSessionDownloadTask *downloadLogoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
            UIImage *downloadedLogo = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if(downloadedLogo != nil)
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString * filename = [NSString stringWithFormat:@"%@.jpg", self.editingCompany.name];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
                self.editingCompany.logoURL = path;
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    self.companyName.placeholder = [NSString stringWithFormat:@"%@",self.editingCompany.name];
    self.companyLogo.placeholder = [NSString stringWithFormat:@"%@",self.editingCompany.logoURL];
    self.companyTicker.placeholder = [NSString stringWithFormat:@"%@",self.editingCompany.ticker];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_companyName release];
    [_companyTicker release];
    [_companyLogo release];
    [super dealloc];
}
- (IBAction)deleteCompanyButton:(id)sender {
    DAO *dataAccessObject = [DAO sharedInstanceOfDAO];
    
    [dataAccessObject deleteCompany:self.editingCompany];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end

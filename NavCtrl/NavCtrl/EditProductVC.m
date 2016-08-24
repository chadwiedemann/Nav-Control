//
//  EditProductVC.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/22/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditProductVC.h"
#import "DAO.h"
#import "ProductViewController.h"
#import "WebSiteForProductVC.h"
#define kOFFSET_FOR_KEYBOARD 80.0


@interface EditProductVC ()

@end

@implementation EditProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem:)];
    self.navigationItem.rightBarButtonItem = save;
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.productEditing.name];
    // Do any additional setup after loading the view from its nib.
   
}

-(void)saveItem:sender
{
    
    
    if(![self.nameTextField.text isEqual:@""]){
        self.productEditing.name = [self.nameTextField text];
    }
    if(![self.productURL.text isEqual:@""]){
        self.productEditing.urlString = [self.productURL text];
    }
    if (![self.productImageURL.text isEqual:@""]) {
        self.productEditing.imageURL = [self.productImageURL text];
        NSURL *url1 = [NSURL URLWithString:self.productEditing.imageURL];
        NSURLSessionDownloadTask *downloadLogoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url1 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
            UIImage *downloadedLogo = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if(downloadedLogo != nil)
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *filename = [NSString stringWithFormat:@"%@.jpg", self.productEditing.name];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
                self.productEditing.imageURL = path;
                NSData *data = UIImagePNGRepresentation(downloadedLogo);
                [data writeToFile:path atomically:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"newProductImageDownloaded"
                 object:nil];
            });
        }];
        [downloadLogoTask resume];
    }
    
    
    self.webSiteVC.nsurl = [NSURL URLWithString:self.productEditing.urlString];
    self.webSiteVC.productShown = self.productEditing;
    [self.navigationController popViewControllerAnimated:true];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    self.productURL.placeholder = [NSString stringWithFormat:@"%@",self.productEditing.urlString];
    self.productImageURL.placeholder = [NSString stringWithFormat:@"%@",self.productEditing.imageURL];
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
    [_productURL release];
    [_productImageURL release];
    [_nameTextField release];
    [super dealloc];
}

//keyboard code
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.productURL]||[sender isEqual:self.productImageURL])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
-(void)dismissKeyboard {
    [self.productImageURL resignFirstResponder];
    [self.productURL resignFirstResponder];
    
}

- (IBAction)deleteProduct:(id)sender {
    
    DAO *dataAccessObjest = [DAO sharedInstanceOfDAO];
    [dataAccessObjest removeProductFromCompany:self.companyFrom.name product:self.productEditing];
    ProductViewController *PVC = [[ProductViewController alloc]init];
    PVC.company = self.companyFrom;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end

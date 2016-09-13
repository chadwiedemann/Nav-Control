//
//  EditCompanyVC.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/23/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#define kOFFSET_FOR_KEYBOARD 80.0

#import "EditCompanyVC.h"
#import "CompanyViewController.h"
#import "DAO.h"

@interface EditCompanyVC ()

@end

@implementation EditCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //remove key board when tapping screen
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    //continue with code
    
    self.title = @"Edit Company";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCompany:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToProduct:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    [leftBarButton release];
    
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


- (void)dealloc {
    [_companyName release];
    [_companyTicker release];
    [_companyLogo release];
    [super dealloc];
}


# pragma --- mark buttons

-(void)saveCompany:sender
{
    DAO *dataAccessObject = [DAO sharedInstanceOfDAO];
    [dataAccessObject editCompanyInfo:self.editingCompany name:self.companyName.text ticker:self.companyTicker.text logoURL:self.companyLogo.text];
    
    if(![self.companyTicker.text isEqual:@""]){
        NSString *uppercaseTicker = [self.companyTicker.text uppercaseString];
        self.editingCompany.ticker = uppercaseTicker;
    }
    if(![self.companyName.text isEqual:@""]){
        self.editingCompany.name = self.companyName.text;
    }
    if (![self.companyLogo.text isEqual:@""]) {
        self.editingCompany.logoURL = self.companyLogo.text;
        self.editingCompany.logoString = nil;
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
    
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)backToProduct: sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteCompanyButton:(id)sender {
    DAO *dataAccessObject = [DAO sharedInstanceOfDAO];
    
    [dataAccessObject deleteCompany:self.editingCompany];
    
    
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark --- Hide Keyboard instructions

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
    if ([sender isEqual:self.companyName]||[sender isEqual:self.companyLogo]||[sender isEqual:self.companyTicker])
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
    [self.companyTicker resignFirstResponder];
    [self.companyLogo resignFirstResponder];
    [self.companyName resignFirstResponder];
}

@end

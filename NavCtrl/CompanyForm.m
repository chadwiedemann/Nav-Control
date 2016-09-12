//
//  CompanyForm.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//example url for logo http://upload.wikimedia.org/wikipedia/commons/7/7f/Williams_River-27527.jpg
//  http://channahon.org/wp-content/uploads/2012/10/exxon-mobil_Logo.jpg
//  https://upload.wikimedia.org/wikipedia/commons/8/82/Facebook_icon.jpg


#import "CompanyForm.h"
#import "DAO.h"
#import "CompanyForm.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface CompanyForm ()

@property (nonatomic, retain) DAO *dataAccessObject;

@end

@implementation CompanyForm

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:127.0/255.0 green:180.0/255.0 blue:57.0/255.0 alpha:0.5];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)saveCompanyData:(UIBarButtonItem *)sender {
    
    self.dataAccessObject = [DAO sharedInstanceOfDAO];
    
    Company *newCompany = [[Company alloc]initWithCompanyName:[self.CompanyTextField text] logoURL:[self.companyLogoTextField text] ticker:self.companyTicker.text];
    
    [self.dataAccessObject addCompany:newCompany];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//move the keyboard


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
    if ([sender isEqual:self.CompanyTextField]||[sender isEqual:self.companyTicker]||[sender isEqual:self.companyLogoTextField])
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
- (void)dealloc {
    [_CompanyTextField release];
    [_companyLogoTextField release];
    [_companyTicker release];
    [super dealloc];
}

-(void)dismissKeyboard {
    [self.CompanyTextField resignFirstResponder];
    [self.companyLogoTextField resignFirstResponder];
    [self.companyTicker resignFirstResponder];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end

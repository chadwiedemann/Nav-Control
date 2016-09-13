//
//  ProductFormVC.m
//  NavCtrl
//
//  Created by Chad Wiedemann on 8/17/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "AddProductFormVC.h"
#import "DAO.h"
#import "Product.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface AddProductFormVC ()
@property (nonatomic, retain) DAO *dataAccessObject;
@end

@implementation AddProductFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Add Product";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveProduct:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backToProduct:)];
    self.navigationItem.leftBarButtonItem = btn;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [_productTextField release];
    [_logoImageTextField release];
    [_websiteTextField release];
    [super dealloc];
}



# pragma mark --- buttons

- (void)saveProduct:sender {
    
    self.dataAccessObject = [DAO sharedInstanceOfDAO];
    
    Product *newProduct = [[Product alloc]initWithProductName:self.productTextField.text url:self.websiteTextField.text imageURL:self.logoImageTextField.text company:self.curentCompany.companyID];
    
    [self.dataAccessObject addProductToCompany:self.curentCompany product:newProduct];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)backToProduct:sender
{
    
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
    if ([sender isEqual:self.productTextField])
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
    
    self.productTextField.placeholder = @"Product Name";
    self.logoImageTextField.placeholder = @"Logo Image URL";
    self.websiteTextField.placeholder = @"Product Website";
    
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
    [self.productTextField resignFirstResponder];
    [self.logoImageTextField resignFirstResponder];
    [self.websiteTextField resignFirstResponder];
}


@end

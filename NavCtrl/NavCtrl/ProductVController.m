//
//  ProductVController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductVController.h"
#import "WebSiteForProductVC.h"
#import "Product.h"
#import "Company.h"
#import "AddProductFormVC.h"
#import "DAO.h"

@interface ProductVController ()
@property (nonatomic, retain) DAO *dataAccessObject;
@end

@implementation ProductVController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkIfThereAreProducts];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"newProductImageDownloaded"
                                               object:nil];
    
    self.webSiteVC = [[WebSiteForProductVC alloc] init];
    self.dataAccessObject = [DAO sharedInstanceOfDAO];
    // Uncomment the following line to preserve selection between presentations.
    //     self.productTableView.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                        action:@selector(backToCompany:)];
    
    self.navigationItem.leftBarButtonItem=btn;
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self checkIfThereAreProducts];
    self.companyLabel.text = [NSString stringWithFormat:@"%@ (%@)",self.company.name,self.company.ticker];
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = self.company.name;
    
    UIImage * myImage;
    if (self.company.logoString) {
        myImage = [UIImage imageNamed:self.company.logoString];
    } else {
        myImage = [UIImage imageWithContentsOfFile:self.company.logoURL];
    }
    
    self.companyImage.image = myImage;
    [self.productTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.company.productsSold count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.company.productsSold objectAtIndex:[indexPath row]] name];
    
    UIImage * myImage;
    if ([[self.company.productsSold objectAtIndex:[indexPath row]] imageString]) {
        myImage = [UIImage imageNamed:[[self.company.productsSold objectAtIndex:[indexPath row]] imageString]];
    } else {
        myImage = [UIImage imageWithContentsOfFile:[[self.company.productsSold objectAtIndex:[indexPath row]] imageURL]];
    }
    cell.imageView.image = myImage;
    
    //    cell.imageView.image = [UIImage imageNamed:[[self.company.productsSold objectAtIndex:[indexPath row]] imageURL]];
    return cell;
    
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Product *productToRemove = [self.company.productsSold objectAtIndex:fromIndexPath.row];
    [self.company.productsSold removeObject:productToRemove];
    
    [self.company.productsSold insertObject:productToRemove atIndex:toIndexPath.row];
}






- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DAO *dataAccessOject = [DAO sharedInstanceOfDAO];
    
    [dataAccessOject removeProductFromCompany:self.company product:[self.company.productsSold objectAtIndex:indexPath.row]];
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}



-(void)reloadTable {
    [self.productTableView reloadData];
}

- (void)dealloc {
    [_productTableView release];
    [_companyImage release];
    [_companyLabel release];
    [_noProductView release];
    [super dealloc];
}




-(void)checkIfThereAreProducts
{
    if(!([self.company.productsSold count]==0))
    {
        [self.noProductView setHidden:YES];
    }else{
        [self.noProductView setHidden:NO];
    }
}

# pragma mark --- buttons and transitions

- (IBAction)addProductButton:(id)sender {
    
    self.addProductVC = [[AddProductFormVC alloc]initWithNibName:@"AddProductFormVC" bundle:nil];
    self.addProductVC.curentCompany = self.company;
    
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController pushViewController:self.addProductVC animated:YES];
    
}

-(void)backToCompany: sender
{
    
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addItem:sender {
    
    self.addProductVC = [[AddProductFormVC alloc]initWithNibName:@"AddProductFormVC" bundle:nil];
    self.addProductVC.curentCompany = self.company;
    
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:self.addProductVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.webSiteVC.nsurl = [NSURL URLWithString:[[self.company.productsSold objectAtIndex:indexPath.row] urlString]];
    self.webSiteVC.productShown = [self.company.productsSold objectAtIndex:indexPath.row];
    self.webSiteVC.companyFrom = self.company;
    
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"suckEffect";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:self.webSiteVC animated:YES];
    
}

@end

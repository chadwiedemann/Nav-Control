//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "WebSiteForProductVC.h"
#import "Product.h"
#import "Company.h"
#import "ProductFormVC.h"
#import "DAO.h"

@interface ProductViewController ()
@property (nonatomic, retain) UIStoryboard *mainStoryboard;
@property (nonatomic, retain) DAO *dataAccessObject;
@end

@implementation ProductViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"newProductImageDownloaded"
                                               object:nil];

    self.webSiteVC = [[WebSiteForProductVC alloc] init];
   self.dataAccessObject = [DAO sharedInstanceOfDAO];
    self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.productVC = (ProductFormVC*)[self.mainStoryboard instantiateViewControllerWithIdentifier:@"ProductVC"];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    NSArray *rightButtons = @[addButton,self.editButtonItem];
    self.navigationItem.rightBarButtonItems = rightButtons;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.title = self.company.name;
    

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
        Product *productToRemove = [self.company.productsSold objectAtIndex:fromIndexPath.row];
    [self.company.productsSold removeObject:productToRemove];
    
    [self.company.productsSold insertObject:productToRemove atIndex:toIndexPath.row];

    
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
 
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    self.webSiteVC.nsurl = [NSURL URLWithString:[[self.company.productsSold objectAtIndex:indexPath.row] urlString]];
    self.webSiteVC.productShown = [self.company.productsSold objectAtIndex:indexPath.row];
    self.webSiteVC.companyFrom = self.company;

    
    [self.navigationController pushViewController:self.webSiteVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        [self.company.productsSold removeObjectAtIndex:indexPath.row];
    
    
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)addItem:sender {
    
    self.productVC.curentCompany = self.company;
    [[self navigationController] presentViewController:self.productVC animated:YES completion:nil];
}

-(void)reloadTable {
    [self.tableView reloadData];
}

@end

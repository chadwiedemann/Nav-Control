//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"
#import "NavControllerAppDelegate.h"
#import "Company.h"
#import "Product.h"
#import "DAO.h"
#import "CompanyForm.h"

@interface CompanyViewController ()

@property (nonatomic, retain) DAO *dataAccessObject;
@property (nonatomic, retain) CompanyForm *companyFormVC;
@property (nonatomic, retain) UIStoryboard *mainStoryboard;
@end

@implementation CompanyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {

    }
    return self;
}

-(void)reloadTable {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.editCompanyVC = [[EditCompanyVC alloc]init];
    self.dataAccessObject = [DAO sharedInstanceOfDAO];
    self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.companyFormVC = (CompanyForm*)[self.mainStoryboard instantiateViewControllerWithIdentifier:@"CompanyFormVC"];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"Watch List";
    self.tableView.editing = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"newCompanyImageDownloaded"
                                               object:nil];
    
    
}





-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self loadCompaniesQuotes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCompaniesQuotes
{
    NSString *quoteQueryString=@"";
    for (Company *company in self.dataAccessObject.companyList){
        quoteQueryString=[NSString stringWithFormat:@"%@,%@",company.ticker,quoteQueryString];
    }
    quoteQueryString=[quoteQueryString substringToIndex:[quoteQueryString length]-1];
    NSLog(@"%@",quoteQueryString);
    NSString *queryURLString=[NSString stringWithFormat:@"https://www.google.com/finance/info?q=%@",quoteQueryString];
    NSLog(@"%@",queryURLString);
    NSURL *stockURL = [NSURL URLWithString:queryURLString];
    NSURLSessionDataTask *downloadQuotes = [[NSURLSession sharedSession]dataTaskWithURL:stockURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *putInString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//puts the JSON data into a string
        NSString *newString = [putInString substringFromIndex:3];
        self.JSONData = [newString dataUsingEncoding:NSUTF8StringEncoding];
        self.stockInfoArray = [NSJSONSerialization JSONObjectWithData:self.JSONData options:NSJSONReadingMutableContainers error:nil]; //creates a dicionary with the JSON data
        NSLog(@"%@",newString);
        NSLog(@"%@",[[self.stockInfoArray objectAtIndex:0] valueForKey:@"l"]);
        
        for(NSDictionary *companyDic in self.stockInfoArray){
            NSString *companyTicker = [companyDic valueForKey:@"t"];
            Company *company = [self.dataAccessObject findCompanyByTicker:companyTicker];
            company.currentStockPrice = [companyDic[@"l_fix"] floatValue];
        }
        [self reloadTable];
        /*for(NSInteger i = 0;i < self.stockInfoArray.count;i++){
            
            if([company.ticker isEqualToString:[NSString stringWithFormat:@"%@",[[self.stockInfoArray objectAtIndex:i] valueForKey:@"t"]]] ){
                
                cell.detailTextLabel.text = [[self.stockInfoArray objectAtIndex:i] valueForKey:@"l"];
            }
            
        }*/
        
    }];
    [downloadQuotes resume];
    
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
    
    return [self.dataAccessObject.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.showsReorderControl = YES;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Company *company = [self.dataAccessObject.companyList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",  company.name,company.ticker];
    UIImage * myImage;
    if (company.logoString) {
        myImage = [UIImage imageNamed:company.logoString];
    } else {
        myImage = [UIImage imageWithContentsOfFile:company.logoURL];
    }
    cell.imageView.image = myImage;
    cell.detailTextLabel.text = @"";
    if(company.currentStockPrice >0.0){
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",company.currentStockPrice];
    }
    
    
    
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


//// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *object= [self.dataAccessObject.companyList objectAtIndex:fromIndexPath.row];
    [self.dataAccessObject.companyList removeObject:object];
    [self.dataAccessObject.companyList insertObject:object atIndex:toIndexPath.row];
    /*[self.companyList exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];*/
    
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(self.tableView.editing){
        
        self.editCompanyVC.editingCompany = [self.dataAccessObject.companyList objectAtIndex:indexPath.row];
        [self.navigationController
         pushViewController:self.editCompanyVC
         animated:YES];
    }else{
        self.productViewController.company = [self.dataAccessObject.companyList objectAtIndex:indexPath.row];
        [self.navigationController
         pushViewController:self.productViewController
         animated:YES];
    }
    
    

}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataAccessObject.companyList removeObjectAtIndex:indexPath.row];
    
    [tableView reloadData];
}

- (void)addItem:sender {
    
    
    [[self navigationController] presentViewController:self.companyFormVC animated:YES completion:nil];
}

//-(void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    NSLog(@"editing began");
//}
@end

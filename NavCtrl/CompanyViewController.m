//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductVController.h"
#import "NavControllerAppDelegate.h"
#import "Company.h"
#import "Product.h"
#import "DAO.h"
#import "AddCompanyFormVC.h"

@interface CompanyViewController ()

@property (nonatomic, retain) DAO *dataAccessObject;
@property (nonatomic, retain) AddCompanyFormVC *addCompanyFormVC;
@end

@implementation CompanyViewController


-(void)reloadTable {
    [self.companyTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:127.0/255.0 green:180.0/255.0 blue:57.0/255.0 alpha:0.5];
    
    //creating the undo and redo buttons
    
    
    
    
    self.editCompanyVC = [[EditCompanyVC alloc]init];
    self.dataAccessObject = [DAO sharedInstanceOfDAO];
    //hide or unhide
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    //     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButton:)];
    self.noCompaniesImageView.image = [UIImage imageNamed:@"nocompanies"];
    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.title = @"Stock Tracker";
    [self.companyTableView setEditing:YES animated:YES];
    
    self.companyTableView.editing = NO;
    self.companyTableView.allowsSelectionDuringEditing = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"newCompanyImageDownloaded"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"newTickerDownloaded"
                                               object:nil];
    
    
    
    
}





-(void)viewWillAppear:(BOOL)animated
{
    [self.companyTableView reloadData];
    [self checkIfThereAreCompanies];
    self.stockPriceReloadTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(loadCompaniesQuotes) userInfo:nil repeats:YES];
    self.firstTimeViewDidAppearCounter = 1;
    
}

-(void)checkIfThereAreCompanies
{
    if(!([self.dataAccessObject.companyList count]==0))
    {
        [self.noCompaniesView setHidden:YES];
        [self loadCompaniesQuotes];
    }else{
        [self.noCompaniesView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCompaniesQuotes
{
    
    
    NSLog(@"quotes reloaded");
    NSString *quoteQueryString=@"";
    for (Company *company in self.dataAccessObject.companyList){
        quoteQueryString=[NSString stringWithFormat:@"%@,%@",company.ticker,quoteQueryString];
    }
    quoteQueryString=[quoteQueryString substringToIndex:[quoteQueryString length]-1];
    //    NSLog(@"%@",quoteQueryString);
    NSString *queryURLString=[NSString stringWithFormat:@"https://www.google.com/finance/info?q=%@",quoteQueryString];
    //    NSLog(@"%@",queryURLString);
    NSURL *stockURL = [NSURL URLWithString:queryURLString];
    NSURLSessionDataTask *downloadQuotes = [[NSURLSession sharedSession]dataTaskWithURL:stockURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            
            if(self.firstTimeViewDidAppearCounter == 1 ){
            [self showNoInternetAlert];
                self.firstTimeViewDidAppearCounter++;
            }
            DAO *dao = [DAO sharedInstanceOfDAO];
            for(Company *c in dao.companyList){
                c.currentStockPrice = 0.00;
            }
            [self.companyTableView reloadData];
            NSLog(@"there is no internet connection");
        }else{
            self.firstTimeViewDidAppearCounter = 1;
            NSString *putInString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//puts the JSON data into a string
            NSString *newString = [putInString substringFromIndex:3];
            [putInString release];
            self.JSONData = [newString dataUsingEncoding:NSUTF8StringEncoding];
            self.stockInfoArray = [NSJSONSerialization JSONObjectWithData:self.JSONData options:NSJSONReadingMutableContainers error:nil]; //creates a dicionary with the JSON data
            
            for(NSDictionary *companyDic in self.stockInfoArray){
                NSString *companyTicker = [companyDic valueForKey:@"t"];
                Company *company = [self.dataAccessObject findCompanyByTicker:companyTicker];
                company.currentStockPrice = [companyDic[@"l_fix"] floatValue];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"newTickerDownloaded"
                 object:nil];
            });
        }
    }];
    [downloadQuotes resume];
    
}



#pragma mark - Table view data source

-(void)editButton:sender
{
    if(!self.companyTableView.editing)
    {
        [self.companyTableView setEditing:YES animated:YES];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButton:)];
        self.navigationItem.leftBarButtonItem = doneButton;
        
    }else
    {
        [self.companyTableView setEditing:NO animated:YES];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButton:)];
        self.navigationItem.leftBarButtonItem = editButton;
    }
}

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
    
    if(company.currentStockPrice >= 0.0){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f",company.currentStockPrice];
    }
    
    
    
    return cell;
}

-(void)showNoInternetAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Conectivity Alert" message:@"Stock data unavailable please establish conection" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.dataAccessObject.companyList removeObjectAtIndex:indexPath.row];
    DAO *dataAccessObject = [DAO sharedInstanceOfDAO];
    
    [dataAccessObject deleteCompany: self.dataAccessObject.companyList[indexPath.row]];
    
    
    [tableView reloadData];
    [self checkIfThereAreCompanies];
    
    
}



- (void)dealloc {
    [_companyTableView release];
    [_noCompaniesImageView release];
    [_noCompaniesView release];
    [super dealloc];
}

- (IBAction)undoButton:(id)sender {
    [self.dataAccessObject undoMethod];
    [self reloadTable];
    [self checkIfThereAreCompanies];
}

- (IBAction)redoButton:(id)sender {
    [self.dataAccessObject redoMethod];
    [self reloadTable];
    [self checkIfThereAreCompanies];
}



-(void)viewDidDisappear:(BOOL)animated
{
    [self.stockPriceReloadTimer invalidate];
}

#pragma mark --- transitions and buttons

- (IBAction)addCompanyButton:(id)sender {
    self.addCompanyFormVC = [[AddCompanyFormVC alloc]initWithNibName:@"AddCompanyFormVC" bundle:nil];
    
    
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:self.addCompanyFormVC animated:YES];
}



- (void)addItem:sender {
    
    self.addCompanyFormVC = [[AddCompanyFormVC alloc]initWithNibName:@"AddCompanyFormVC" bundle:nil];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:self.addCompanyFormVC animated:NO];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.companyTableView.editing){
        self.editCompanyVC.editingCompany = [self.dataAccessObject.companyList objectAtIndex:indexPath.row];
        
        CATransition* transition = [CATransition animation];
        transition.duration = .5;
        transition.type = @"rippleEffect";
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self.navigationController
         pushViewController:self.editCompanyVC
         animated:YES];
    }else{
        self.productViewController = [[ProductVController alloc]initWithNibName:@"ProductVController" bundle:nil];
        self.productViewController.company = [self.dataAccessObject.companyList objectAtIndex:indexPath.row];
        
        CATransition* transition = [CATransition animation];
        transition.duration = .5;
        transition.type = @"oglFlip";
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self.navigationController pushViewController:self.productViewController animated:YES];
    }
    
}


@end

//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "WebSiteForProductVC.h"

@interface ProductViewController ()

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
    self.webSiteVC = [[WebSiteForProductVC alloc] init];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.productURLDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.apple.com/ipod/",@"iPod Touch",@"http://www.apple.com/ipad/",@"iPad",@"http://www.apple.com/iphone/",@"iPhone",@"http://www.samsung.com/us/mobile/phones/galaxy-s/samsung-galaxy-s4-verizon-white-frost-16gb-sch-i545zwavzw/",@"Galaxy S4",@"http://www.samsung.com/us/explore/galaxy-note-7-features-and-specs/?cid=ppc-",@"Galaxy Note",@"http://www.samsung.com/us/explore/tab-s2-features-and-specs/?cid=ppc-",@"Galaxy Tab",@"http://www.htc.com/us/smartphones/htc-one-m9/",@"One M9",@"http://www.htc.com/us/smartphones/htc-desire-626/",@"Desire 626 Series",@"http://www.htc.com/us/smartphones/htc-desire-eye/",@"Desire EYE",@"http://us.blackberry.com/smartphones/blackberry-passport/overview.html",@"Passport",@"http://us.blackberry.com/smartphones/blackberry-classic/overview.html",@"Classic",@"http://us.blackberry.com/smartphones/blackberry-leap/overview.html",@"LEAP", nil];
   
        self.appleProducts = [NSMutableArray arrayWithObjects:@"iPad", @"iPod Touch",@"iPhone", nil];
        self.appleProductImages = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"iPad"],[UIImage imageNamed:@"iPod"],[UIImage imageNamed:@"iPhone"], nil];
    
        self.samsungProducts = [NSMutableArray arrayWithObjects:@"Galaxy S4", @"Galaxy Note", @"Galaxy Tab", nil];
        self.samsungProductImages = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"S4"],[UIImage imageNamed:@"Note"],[UIImage imageNamed:@"Tab"], nil];
   
        self.HTCProducts = [NSMutableArray arrayWithObjects:@"One M9",@"Desire 626 Series", @"Desire EYE", nil];
        self.HTCProductImages = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"onem9.jpeg"],[UIImage imageNamed:@"desire626.png"],[UIImage imageNamed:@"desireeye.png"], nil];
    
        self.blackberryProducts = [NSMutableArray arrayWithObjects:@"Passport",@"Classic",@"LEAP", nil];
        self.blackberryProductImages =[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"passport.jpeg"],[UIImage imageNamed:@"classic.png"],[UIImage imageNamed:@"LEAP.jpeg"], nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([self.title isEqualToString:@"Apple mobile devices"]) {
       return [self.appleProducts count];
    } else if([self.title isEqualToString:@"Samsung mobile devices"]){
        return [self.samsungProducts count];
    }else if ([self.title isEqualToString:@"HTC mobile devices"]){
        return [self.HTCProducts count];
    }else{
       return [self.blackberryProducts count];
    }

    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if ([self.title isEqualToString:@"Apple mobile devices"]) {
        cell.textLabel.text = [self.appleProducts objectAtIndex:[indexPath row]];
        cell.imageView.image = [self.appleProductImages objectAtIndex:[indexPath row]];
        return cell;
    } else if([self.title isEqualToString:@"Samsung mobile devices"]){
        cell.textLabel.text = [self.samsungProducts objectAtIndex:[indexPath row]];
        cell.imageView.image = [self.samsungProductImages objectAtIndex:[indexPath row]];
        return cell;
    }else if ([self.title isEqualToString:@"HTC mobile devices"]){
        cell.textLabel.text = [self.HTCProducts objectAtIndex:[indexPath row]];
        cell.imageView.image = [self.HTCProductImages objectAtIndex:[indexPath row]];
        return cell;
    }else{
        cell.textLabel.text = [self.blackberryProducts objectAtIndex:[indexPath row]];
        cell.imageView.image = [self.blackberryProductImages objectAtIndex:[indexPath row]];
        return cell;
    }

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
    if ([self.title isEqualToString:@"Apple mobile devices"]) {
        NSString *productToRemove = [self.appleProducts objectAtIndex:fromIndexPath.row];
        [self.appleProducts removeObject:productToRemove];
        [self.appleProducts insertObject:productToRemove atIndex:toIndexPath.row];
        
    } else if([self.title isEqualToString:@"Samsung mobile devices"]){
        NSString *productToRemove = [self.samsungProducts objectAtIndex:fromIndexPath.row];
        [self.samsungProducts removeObject:productToRemove];
        [self.samsungProducts insertObject:productToRemove atIndex:toIndexPath.row];
    }else if ([self.title isEqualToString:@"HTC mobile devices"]){
        NSString *productToRemove = [self.HTCProducts objectAtIndex:fromIndexPath.row];
        [self.HTCProducts removeObject:productToRemove];
        [self.HTCProducts insertObject:productToRemove atIndex:toIndexPath.row];
    }else{
        NSString *productToRemove = [self.blackberryProducts objectAtIndex:fromIndexPath.row];
        [self.blackberryProducts removeObject:productToRemove];
        [self.blackberryProducts insertObject:productToRemove atIndex:toIndexPath.row];
    }

    
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
    
    
    if ([self.title isEqualToString:@"Apple mobile devices"]) {
        self.webSiteVC.nsurl = [NSURL URLWithString:[self.productURLDictionary objectForKey:[self.appleProducts objectAtIndex:[indexPath row]]]];
    } else if([self.title isEqualToString:@"Samsung mobile devices"]){
        self.webSiteVC.nsurl = [NSURL URLWithString:[self.productURLDictionary objectForKey:[self.samsungProducts objectAtIndex:[indexPath row]]]];
    }else if ([self.title isEqualToString:@"HTC mobile devices"]){
        self.webSiteVC.nsurl = [NSURL URLWithString:[self.productURLDictionary objectForKey:[self.HTCProducts objectAtIndex:[indexPath row]]]];
    }else{
        self.webSiteVC.nsurl = [NSURL URLWithString:[self.productURLDictionary objectForKey:[self.blackberryProducts objectAtIndex:[indexPath row]]]];
    }


    
    [self.navigationController pushViewController:self.webSiteVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.title isEqualToString:@"Apple mobile devices"]) {
        [self.appleProducts removeObjectAtIndex:indexPath.row];
        [self.appleProductImages removeObjectAtIndex:indexPath.row];
    } else if([self.title isEqualToString:@"Samsung mobile devices"]){
        [self.samsungProducts removeObjectAtIndex:indexPath.row];
        [self.samsungProductImages removeObjectAtIndex:indexPath.row];
    }else if ([self.title isEqualToString:@"HTC mobile devices"]){
        [self.HTCProducts removeObjectAtIndex:indexPath.row];
        [self.HTCProductImages removeObjectAtIndex:indexPath.row];
    }else{
        [self.blackberryProducts removeObjectAtIndex:indexPath.row];
        [self.blackberryProductImages removeObjectAtIndex:indexPath.row];
    }


    
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

@end

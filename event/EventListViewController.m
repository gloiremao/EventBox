//
//  EventListViewController.m
//  event
//
//  Created by Mao Chen-Ning on 2013/12/26.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailViewController.h"
#import <Parse/Parse.h>

@interface EventListViewController ()

@end

@implementation EventListViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName =@"Event";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"Event";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    if ([PFUser currentUser]) {
        //NSLog(@"Current User %@ login",[[PFUser currentUser] objectForKey:@"name"]);
    }else{
        //NSLog(@"Not login");
    }
    [super viewDidLoad];
        // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    static NSString *CellIdentifier = @"Cell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = object[@"Event"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Holder is: %@",object[@"Name"]];
    
    UIImage *image = [UIImage imageNamed:@"box.png"];
    NSString *selectedCategory = object[@"Category"];
    if([selectedCategory isEqualToString:@"Dinner Party"])image = [UIImage imageNamed:@"dinner.jpg"];
    else if([selectedCategory isEqualToString:@"Metting"])image = [UIImage imageNamed:@"meeting.png"];
    else if([selectedCategory isEqualToString:@"Classical Concert"])image = [UIImage imageNamed:@"classical.jpg"];
    else if([selectedCategory isEqualToString:@"Popular Concert"])image = [UIImage imageNamed:@"popconcert.jpg"];
    else if([selectedCategory isEqualToString:@"Party"])image = [UIImage imageNamed:@"party.jpg"];
    else if([selectedCategory isEqualToString:@"Travel"])image = [UIImage imageNamed:@"travel.png"];
    else if([selectedCategory isEqualToString:@"Date"])image = [UIImage imageNamed:@"date.jpg"];
    
    cell.imageView.image = image;
    
    return cell;
}

- (PFQuery *)queryForTable {
    PFQuery *myEvent = [PFQuery queryWithClassName:@"Event"];
    NSString *currentUserName = [[PFUser currentUser] objectForKey:@"name"];
    [myEvent whereKey:@"Name" equalTo:currentUserName];
    
    PFQuery *publicEvent = [PFQuery queryWithClassName:@"Event"];
    [publicEvent whereKey:@"isPrivacy" equalTo:@NO];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[myEvent,publicEvent]];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"showDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PFObject *selectedObject = [self objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:selectedObject.objectId];

        
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want th<#(id)#>e specified item to be editable.
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

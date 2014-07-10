//
//  FriendListViewController.m
//  event
//
//  Created by Mao Chen-Ning on 2013/12/30.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import "FriendListViewController.h"
#import "CRTableViewCell.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendListViewController ()

@end
//NSDictionary<FBGraphUser> *friend;
NSDictionary<FBGraphUser>* friend;

@implementation FriendListViewController
@synthesize dataArray;
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
    selectedMarks = [[NSMutableArray alloc] init];
    dataArray = [[PFUser currentUser] objectForKey:@"FriendList"];
    //NSLog(@"co %d",dataArray.count);
    [super viewDidLoad];
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
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
    
    // init the CRTableViewCell
    CRTableViewCell *cell = (CRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRTableViewCellIdentifier];
    }
    
    // Check if the cell is currently selected (marked)
    //NSString *text = [dataArray objectAtIndex:[indexPath row]];
    NSString *name = [dataArray objectAtIndex:[indexPath row]];
    //NSLog(@"cell %@",name);
    cell.isSelected = [selectedMarks containsObject:name] ? YES : NO;
    cell.textLabel.text = name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [dataArray objectAtIndex:[indexPath row]];
    
    if ([selectedMarks containsObject:text])// Is selected?
        [selectedMarks removeObject:text];
    else
        [selectedMarks addObject:text];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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


- (IBAction)Submit:(id)sender {
    //NSLog(@"Hello");
    //NSLog(@"Tst %@",[[PFUser currentUser] objectForKey:@"currentEvent"]);
    if([PFUser currentUser]){
        
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:[[PFUser currentUser] objectForKey:@"currentEvent"]  block:^(PFObject *event, NSError *error) {
            if(!error){
                event[@"invite"] = selectedMarks;
                //NSLog(@"%@",[event objectForKey:@"Event"]);
                [event saveInBackground];
            }else{
                NSLog(@"Fail");
            }
            
        }];
        [self performSegueWithIdentifier:@"EventDone" sender:self];
    }
    else{
        NSLog(@"Fail");
    }
}
@end

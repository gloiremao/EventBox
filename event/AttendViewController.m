//
//  AttendViewController.m
//  event
//
//  Created by Mao Chen-Ning on 2014/1/2.
//  Copyright (c) 2014年 nthu.edu.cs.100062235. All rights reserved.
//

#import "AttendViewController.h"
#import "CRTableViewCell.h"
#import <Parse/Parse.h>

@interface AttendViewController ()

@end

@implementation AttendViewController

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
    //dataArray = [[PFUser currentUser] objectForKey:@"FriendList"];
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
- (IBAction)DateSelectButton:(id)sender {
    if(selectedMarks){
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        NSString *eventID = [[NSString alloc] init];
        eventID = [[PFUser currentUser] objectForKey:@"currentEvent"];
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:eventID block:^(PFObject *event, NSError *error) {
            if (!error) {
                NSMutableDictionary *statistics =[[NSMutableDictionary alloc] init];
                statistics = [event objectForKey:@"Statistics"];
                NSMutableArray *date = [[NSMutableArray alloc] initWithArray:[statistics objectForKey:@"Date"]];
                NSMutableArray *mysta = [[NSMutableArray alloc] initWithArray:[statistics objectForKey:@"Statistics"]];
                int index;
                for (int i = 0; i < [selectedMarks count]; i++) {
                    if ([date containsObject:[selectedMarks objectAtIndex:i]]) {
                        index = [date indexOfObject:[selectedMarks objectAtIndex:i]];
                        int count = [[mysta objectAtIndex:index] integerValue];
                        
                        count++;
                        //NSLog(@"%d",count);
                        [mysta replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:count]];
                    }
                }
                statistics[@"Statistics"] = mysta;
                [event setObject:statistics forKey:@"Statistics"];
                [event saveInBackground];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"You have to choose at least one date!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
}
@end

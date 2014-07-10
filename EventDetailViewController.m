//
//  EventDetailViewController.m
//  event
//
//  Created by Mao Chen-Ning on 2013/12/27.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import "EventDetailViewController.h"
#import <Parse/Parse.h>
#import "AttendViewController.h"

@interface EventDetailViewController ()

@end
NSMutableArray *date;

@implementation EventDetailViewController

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        PFQuery *detailObject = [PFQuery queryWithClassName:@"Event"];
        [detailObject getObjectInBackgroundWithId:self.detailItem block:^(PFObject *Event, NSError *error) {
            if (!error){
                self.Event.text = [Event objectForKey:@"Event"];
                self.Location.text = Event[@"Place"];
                self.Holder.text = Event[@"Name"];
                if ([[[PFUser currentUser] objectForKey:@"name"] isEqualToString:Event[@"Name"]]) {
                    [self.GoView setHidden:false];
                }else{
                    NSLog(@"bug");
                }
                [self.CategoryImage setImage:[self chooseCategory:[Event objectForKey:@"Category"]]];
                date = [Event objectForKey:@"Date"];
                if(Event[@"PerfectDate"]){
                    self.Time.text = Event[@"PerfectDate"];
                    [self.GoView setHidden:TRUE];
                    [self.AttendView setHidden:TRUE];
                    UIImage *done = [UIImage imageNamed:@"approved.png"];
                    [self.DoneImage setImage:done];
                }else{
                    self.Time.text = @"Not decided!";
                }
                
                NSMutableDictionary *statistics =[[NSMutableDictionary alloc] init];
                statistics = [Event objectForKey:@"Statistics"];
                NSMutableArray *date = [[NSMutableArray alloc] initWithArray:[statistics objectForKey:@"Date"]];
                NSMutableArray *mysta = [[NSMutableArray alloc] initWithArray:[statistics objectForKey:@"Statistics"]];
                int index = 0;
                for (int i = 1; i < [date count]; i++) {
                    if([[mysta objectAtIndex:i] integerValue] > [[mysta objectAtIndex:index] integerValue]){
                        index = i;
                    }
                }
                //NSLog(@"%d",index);
                self.Date1.text = [date objectAtIndex:index];
                self.n1.text = [NSString stringWithFormat:@"%d",[[mysta objectAtIndex:index] integerValue]];
                
                [[PFUser currentUser] setObject:Event.objectId forKey:@"currentEvent"];
                [[PFUser currentUser] saveInBackground];
            }else {
                NSLog(@"Error at configure detail view");
            }
        }];
    }
}
-(UIImage *)chooseCategory:(NSString *)selectedCategory{
    
    UIImage *image = [UIImage imageNamed:@"box.png"];
    if([selectedCategory isEqualToString:@"Dinner Party"])image = [UIImage imageNamed:@"dinner.jpg"];
    else if([selectedCategory isEqualToString:@"Metting"])image = [UIImage imageNamed:@"meeting.png"];
    else if([selectedCategory isEqualToString:@"Classical Concert"])image = [UIImage imageNamed:@"classical.jpg"];
    else if([selectedCategory isEqualToString:@"Popular Concert"])image = [UIImage imageNamed:@"popconcert.jpg"];
    else if([selectedCategory isEqualToString:@"Party"])image = [UIImage imageNamed:@"party.jpg"];
    else if([selectedCategory isEqualToString:@"Travel"])image = [UIImage imageNamed:@"travel.png"];
    else if([selectedCategory isEqualToString:@"Date"])image = [UIImage imageNamed:@"date.jpg"];
    return image;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Attend:(id)sender {
    if (self.detailItem) {
        PFQuery *detailObject = [PFQuery queryWithClassName:@"Event"];
        [detailObject getObjectInBackgroundWithId:self.detailItem block:^(PFObject *Event, NSError *error) {
            if (!error){
                NSMutableArray *Attend = [[NSMutableArray alloc] init];
                Attend = [Event objectForKey:@"Attend"];
                if ([Attend containsObject:[[PFUser currentUser] objectForKey:@"name"]]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey!Wellcome" message:@"You have already attend!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    NSLog(@"You have already attend");
                }else{
                    [Attend addObject:[[PFUser currentUser] objectForKey:@"name"]];
                    [Event setObject:Attend forKey:@"Attend"];
                    [Event saveInBackground];
                }
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"We have some technical problem!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                NSLog(@"Error at detail view Attend");
            }
        }];
    }
    //NSLog(@"%@",date);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShowSelectView"]){
        AttendViewController *myView = (AttendViewController *)segue.destinationViewController;
        myView.dataArray = date;
        
    }
}
- (IBAction)GoButton:(id)sender {
    PFQuery *detailObject = [PFQuery queryWithClassName:@"Event"];
    [detailObject getObjectInBackgroundWithId:self.detailItem block:^(PFObject *Event, NSError *error) {
        if (!error){
            [Event setObject:self.Date1.text forKey:@"PerfectDate"];
            [Event saveInBackground];
            [self.GoView setHidden:TRUE];
            [self.AttendView setHidden:TRUE];
            self.Time.text = self.Date1.text;
            UIImage *done = [UIImage imageNamed:@"approved.png"];
            [self.DoneImage setImage:done];
        }else {
            NSLog(@"Error at detail view Go ");
        }
    }];
}
- (IBAction)CancelButton:(id)sender {
    
    PFQuery *delet = [PFQuery queryWithClassName:@"Event"];
    [delet getObjectInBackgroundWithId:self.detailItem block:^(PFObject *deletEvent, NSError *error) {
        if (!error) {
            if ([[[PFUser currentUser] objectForKey:@"name"] isEqualToString:[deletEvent objectForKey:@"Name"]]) {
                [deletEvent deleteInBackground];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You are not the holder!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
    [self.navigationController popToRootViewControllerAnimated:YES ];
}
@end

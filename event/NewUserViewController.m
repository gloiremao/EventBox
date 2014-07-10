//
//  NewUserViewController.m
//  event
//
//  Created by nthu on 13/12/14.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import "NewUserViewController.h"
#import <Parse/Parse.h>

@interface NewUserViewController ()

@end

@implementation NewUserViewController

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
    if ([PFUser currentUser]) {
        NSLog(@"current user login %@",[[PFUser currentUser] objectId]);
    }else{
        NSLog(@"Failed");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DoneButton:(id)sender {
    [self.email2 resignFirstResponder];
    [_email resignFirstResponder];
    if (self.email2.text.length <=0 || self.email.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"E-mail not correct" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            // handle response
            if (!error) {
                // Parse the data received
                NSDictionary *userData = (NSDictionary *)result;
                NSString *facebookID = userData[@"id"];
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                NSLog(@"url %@",pictureURL);
                PFUser *new = [PFUser currentUser];
                
                if (userData[@"name"]) {
                    [new setObject:userData[@"name"] forKey:@"name"];
                    //[[PFUser currentUser] setObject:userData[@"name"] forKey:@"name"];
                    NSLog(@"name is %@",userData[@"name"]);
                }
                if (userData[@"birthday"]) {
                    [new setObject:userData[@"birthday"] forKey:@"birthday"];
                    //[[PFUser currentUser] setObject:userData[@"birthday"] forKey:@"birthday"];
                }
                
                //PFUser *test = [PFUser currentUser];
                new.email = self.email.text;
                [new setValue:facebookID forKey:@"facebookID"];
                //[new setValue:pictureURL forKey:@"URL"];
                NSLog(@"test %@",new.objectId);
                
                [new saveInBackground];
                //[[PFUser currentUser] setObject:self.email.text forKey:@"email"];
                //[[PFUser currentUser] setObject:pictureURL forKey:@"URL"];
                
                //[[PFUser currentUser] saveInBackground];
                
            } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                        isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
            } else {
                NSLog(@"Some other error: %@", error);
            }
        }];
        [self performSegueWithIdentifier:@"signback" sender:nil];
    }
    
}

- (IBAction)Logout:(id)sender {
    [PFUser logOut];
    if ([PFUser currentUser]) {
        NSLog(@"Fail logout");
    }else {
        NSLog(@"User Logout");
    }
}
@end

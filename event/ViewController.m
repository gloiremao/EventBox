//
//  ViewController.m
//  event
//
//  Created by nthu on 13/12/11.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "EventListViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    if([PFUser currentUser]){
        [self FBfriendList];
        [self.LoginButtonArea setHidden:TRUE];
        [self.LogoutButtonArea setHidden:FALSE];
    }else{
        [self.LoginButtonArea setHidden:FALSE];
        [self.LogoutButtonArea setHidden:TRUE];
        [self.pushButtonArea setHidden:TRUE];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Start:(id)sender {
    
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)FBlogin user:(id<FBGraphUser>)user {
    self.Name.text = user.name;
    self.FBImage.profileID = user.id;
    NSLog(@"ID is %@",user.id);
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.FBImage.profileID = nil;
    self.Name.text = @"You're not logged in!";
}


- (IBAction)LoginButtonHandler:(id)sender {
    NSArray *permissionArray = @[@"basic_info",@"user_about_me",@"user_relationships",@"user_birthday",@"read_friendlists"];
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            
            NSLog(@"User with facebook signed up and logged in!");
            [self performSegueWithIdentifier:@"setNewUser" sender:self];
            [self.pushButtonArea setHidden:FALSE];
        } else {
            NSLog(@"User with facebook logged in!");
            //[self performSegueWithIdentifier:@"setNewUser" sender:self];
            [self.LoginButtonArea setHidden:TRUE];
            [self.LogoutButtonArea setHidden:FALSE];
            [self.pushButtonArea setHidden:FALSE];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
    
}
-(void)FBfriendList{
    if ([PFUser currentUser]) {
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            
            NSArray* friends = [result objectForKey:@"data"];
            NSMutableArray *list = [[NSMutableArray alloc] init];
            //NSLog(@"%@",friends);
            
            for (NSDictionary<FBGraphUser> *friend in friends) {
                //NSLog(@"I have a friend named %@ ", friend.name);
                [list addObject:friend.name];
            }
            [[PFUser currentUser] setObject:list forKey:@"FriendList"];
            [[PFUser currentUser] saveInBackground];
            //UIStoryboardSegue *segue
            //[[segue destinationViewController] setDetailItem:selectedObject.objectId];*/
        }];
    }
}

- (IBAction)List:(id)sender {
}

- (IBAction)Logout:(id)sender {
    [PFUser logOut];
    [self.LoginButtonArea setHidden:FALSE];
    [self.LogoutButtonArea setHidden:TRUE];
    [self.pushButtonArea setHidden:TRUE];
}
@end

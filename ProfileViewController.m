//
//  ProfileViewController.m
//  event
//
//  Created by Mao Chen-Ning on 2013/12/28.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"aboutmebg2.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    if ([PFUser currentUser]){
        NSLog(@"Login Profile view");
        self.UserName.text = [[PFUser currentUser] objectForKey:@"name"];
        self.email.text = [[PFUser currentUser] objectForKey:@"email"];
        self.ProfileID.text = [[PFUser currentUser] objectForKey:@"facebookID"];
        NSLog(@"%@",[[PFUser currentUser] objectForKey:@"name"]);
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:@"facebookID"]]];
        UIImage *p = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageURL]];
        [self.profile setImage:p];
        
    }else{
        NSLog(@"Fail");
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Logout:(id)sender {
    if([PFUser currentUser]){
        [PFUser logOut];
    }
}
@end

//
//  ProfileViewController.h
//  event
//
//  Created by Mao Chen-Ning on 2013/12/28.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ProfileID;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UITableView *oweEventView;
@property (strong, nonatomic) IBOutlet UIImageView *profile;




- (IBAction)Logout:(id)sender;

@end

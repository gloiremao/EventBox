//
//  ViewController.h
//  event
//
//  Created by nthu on 13/12/11.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>


@interface ViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, FBLoginViewDelegate>{
    FBLoginView *FBlogin;
}
- (IBAction)Start:(id)sender;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *FBImage;

@property (weak, nonatomic) IBOutlet UILabel *Name;
- (IBAction)LoginButtonHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *LoginButtonArea;
@property (weak, nonatomic) IBOutlet UIView *LogoutButtonArea;
@property (weak, nonatomic) IBOutlet UIView *pushButtonArea;
- (IBAction)List:(id)sender;
- (IBAction)Logout:(id)sender;



@end

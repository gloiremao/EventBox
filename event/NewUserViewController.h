//
//  NewUserViewController.h
//  event
//
//  Created by nthu on 13/12/14.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email2;
@property (weak, nonatomic) IBOutlet UITextField *email;
- (IBAction)DoneButton:(id)sender;

- (IBAction)Logout:(id)sender;

@end

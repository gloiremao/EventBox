//
//  DoneViewController.m
//  event
//
//  Created by Mao Chen-Ning on 2013/12/31.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import "DoneViewController.h"
#import <Parse/Parse.h>

@interface DoneViewController ()

@end

@implementation DoneViewController

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
    if([PFUser currentUser]){
        self.EventID.text = [[PFUser currentUser] objectForKey:@"currentEvent"];
    }else{
        NSLog(@"Fail");
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DoneButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}
@end

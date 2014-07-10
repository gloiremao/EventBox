//
//  EventDetailViewController.h
//  event
//
//  Created by Mao Chen-Ning on 2013/12/27.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendViewController.h"

@interface EventDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSArray *dataSelected;

@property (weak, nonatomic) IBOutlet UIImageView *CategoryImage;
@property (weak, nonatomic) IBOutlet UILabel *Event;
@property (weak, nonatomic) IBOutlet UILabel *Location;
@property (weak, nonatomic) IBOutlet UILabel *Holder;
@property (weak, nonatomic) IBOutlet UILabel *Time;
- (IBAction)Attend:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Date1;

@property (strong, nonatomic) IBOutlet UILabel *n1;
@property (strong, nonatomic) IBOutlet UIView *GoView;
- (IBAction)GoButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *AttendView;
@property (strong, nonatomic) IBOutlet UIImageView *DoneImage;
- (IBAction)CancelButton:(id)sender;

@end

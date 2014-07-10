//
//  AttendViewController.h
//  event
//
//  Created by Mao Chen-Ning on 2014/1/2.
//  Copyright (c) 2014年 nthu.edu.cs.100062235. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendViewController : UITableViewController
{
    NSMutableArray *selectedMarks;
}
@property (strong, nonatomic) id data;
@property (strong,nonatomic) NSArray *dataArray;
- (IBAction)DateSelectButton:(id)sender;

@end

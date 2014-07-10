//
//  FriendListViewController.h
//  event
//
//  Created by Mao Chen-Ning on 2013/12/30.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendListViewController : UITableViewController
{
    NSMutableArray *selectedMarks;
}

- (IBAction)Submit:(id)sender;


@property (nonatomic) NSArray *dataArray;
@end

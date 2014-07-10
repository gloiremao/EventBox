//
//  NewEventController.h
//  event
//
//  Created by nthu on 13/12/11.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTCalendarView.h"

@interface NewEventController : UIViewController <ITTCalendarViewDelegate , UITextFieldDelegate ,UIPickerViewDelegate,UIPickerViewDataSource>
{
    ITTCalendarView *calendar;
    
    IBOutlet UIPickerView *myPicker;
    NSMutableArray *categoryArray;
    NSUInteger selectedRow;
}

@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *Place;
- (IBAction)submit:(id)sender;
- (IBAction)datepicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *eventfield;

@property (weak, nonatomic) IBOutlet UISwitch *privacy;

@property (weak, nonatomic) IBOutlet UISwitch *protect;
- (IBAction)inviteButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;

@property (weak, nonatomic) IBOutlet UIView *CategoryPickerView;
- (IBAction)categoryButton:(id)sender;

- (IBAction)categorySelecting:(id)sender;
- (IBAction)touchBackground:(id)sender;


@end

//
//  NewEventController.m
//  event
//
//  Created by nthu on 13/12/11.
//  Copyright (c) 2013年 nthu.edu.cs.100062235. All rights reserved.
//

#import "NewEventController.h"
#import <Parse/Parse.h>
#import "ITTBaseDataSourceImp.h"


@interface NewEventController ()

@end

@implementation NewEventController
@synthesize Name,Place,eventfield;
@synthesize scrollView;
@synthesize CategoryPickerView,categoryImage;

NSMutableArray *datepicked;
NSMutableArray *dateCounter;
NSString *selectedCategory;

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
    Place.delegate = self;
    Name.delegate = self;
    eventfield.delegate = self;
    
    Place.placeholder = @"Place";
    Name.placeholder = @"Holder";
    eventfield.placeholder = @"Event name";
    
    calendar = [ITTCalendarView viewFromNib];
    ITTBaseDataSourceImp *dataSource = [[ITTBaseDataSourceImp alloc] init];
    calendar.date = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
    calendar.dataSource = dataSource;
    calendar.delegate = self;
    calendar.frame = CGRectMake(8, 40, 309, 410);
    calendar.allowsMultipleSelection = TRUE;
    [calendar hide];
    
    selectedCategory = [[NSString alloc] initWithFormat:@"Default"];
    datepicked = [NSMutableArray arrayWithCapacity:20];
    
    categoryArray = [[NSMutableArray alloc] init];
    [categoryArray addObject:@"Default"];
    [categoryArray addObject:@"Dinner Party"];
    [categoryArray addObject:@"Metting"];
    [categoryArray addObject:@"Classical Concert"];
    [categoryArray addObject:@"Popular Concert"];
    [categoryArray addObject:@"Party"];
    [categoryArray addObject:@"Travel"];
    [categoryArray addObject:@"Date"];
    
    UIImage *image = [UIImage imageNamed:@"box.png"];
    [categoryImage setImage:image];
    
    if ([PFUser currentUser]) {
        NSLog(@"current user %@ login",[[PFUser currentUser] objectForKey:@"name"]);
        self.Name.text = [[PFUser currentUser] objectForKey:@"name"];
    }else{
        NSLog(@"Failed");
        UIAlertView *login = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"You have to login first!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [login show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    PFObject *Event = [PFObject objectWithClassName:@"Event"];
    NSLog(@"number is %d",datepicked.count);

    if(eventfield.text.length <= 0 || Place.text.length <= 0 || Name.text.length <= 0 ||datepicked.count <= 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Some text is empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        if(eventfield.text.length <= 0)alert.message = @"Event is empty!";
        else if(Place.text.length <= 0)alert.message = @"Place is empty";
        else if(datepicked.count <= 0)alert.message = @"You haven't chosen any date!";
        
        [alert show];
        return;
    }else{
        
        Event[@"Name"] = self.Name.text;
        Event[@"Place"] = self.Place.text;
        //Event[@"num"] = self.num.text;
        Event[@"Event"] = self.eventfield.text;
        [Event addObjectsFromArray:datepicked forKey:@"Date"];
        dateCounter = [[NSMutableArray alloc] initWithCapacity:[datepicked count]];
        for (int i = 1; i <= [datepicked count];i++){
            [dateCounter addObject:[NSNumber numberWithInteger:1]];
        }
        //[Event addObjectsFromArray:dateCounter forKey:@"Statistics"];
        NSMutableDictionary *DateSelect = [NSMutableDictionary dictionaryWithCapacity:[datepicked count]];
        if(datepicked){
            DateSelect[@"Date"] = datepicked;
            DateSelect[@"Statistics"] = dateCounter;
            [Event setObject:DateSelect forKey:@"Statistics"];
        }
        NSMutableArray *Attend = [[NSMutableArray alloc] init];
        [Attend addObject:[[PFUser currentUser] objectForKey:@"name"]];
        [Event setObject:Attend forKey:@"Attend"];
        //[Event setObject:DateSelect forKey:@"testDate"];
        //NSLog(@"%@",DateSelect);
        if(self.privacy.on)Event[@"isPrivacy"] = @YES;
        else Event[@"isPrivacy"] = @NO;
        if(self.protect.on)Event[@"isProtect"] = @YES;
        else Event[@"isProtect"] = @NO;
        Event[@"Category"] = selectedCategory;
        //[Event saveInBackground];
        [Event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                NSLog(@"ID is %@",Event.objectId);
                [[PFUser currentUser] setObject:Event.objectId forKey:@"currentEvent"];
                [[PFUser currentUser] saveInBackground];
            }
        }];
        
    }
}

- (IBAction)datepicker:(id)sender {
    if(calendar.appear){
        [calendar hide];
    }else{
        [calendar showInView:self.view];
    }
}
- (void)calendarViewDidSelectDay:(ITTCalendarView*)calendarView calDay:(ITTCalDay*)calDay
{
    NSArray *selectedDates = calendarView.selectedDateArray;
    //NSLog(@"OMG date is %d",[calendarView.selectedDateArray count]);
    if (calendarView.allowsMultipleSelection)
    {
        
        for (NSDate *date in selectedDates)
        {
            
            [datepicked addObject:[self stringFromFomate:date formate:@"yyyy-MM-dd"]];
            NSLog(@"selected date %@", [self stringFromFomate:date formate:@"yyyy-MM-dd"]);
            
        }
    }
}

- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	return str;
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, scrollView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, scrollView.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [Name resignFirstResponder];
    [Place resignFirstResponder];
    [eventfield resignFirstResponder];
    return YES;
}
- (IBAction)inviteButton:(id)sender {
    //[self performSegueWithIdentifier:@"toInviteView" sender:sender];
}

- (IBAction)categoryButton:(id)sender {
    [CategoryPickerView setHidden:TRUE ];
    UIImage *image = [UIImage imageNamed:@"box.png"];
    if([selectedCategory isEqualToString:@"Dinner Party"])image = [UIImage imageNamed:@"dinner.jpg"];
    else if([selectedCategory isEqualToString:@"Metting"])image = [UIImage imageNamed:@"meeting.png"];
    else if([selectedCategory isEqualToString:@"Classical Concert"])image = [UIImage imageNamed:@"classical.jpg"];
    else if([selectedCategory isEqualToString:@"Popular Concert"])image = [UIImage imageNamed:@"popconcert.jpg"];
    else if([selectedCategory isEqualToString:@"Party"])image = [UIImage imageNamed:@"party.jpg"];
    else if([selectedCategory isEqualToString:@"Travel"])image = [UIImage imageNamed:@"travel.png"];
    else if([selectedCategory isEqualToString:@"Date"])image = [UIImage imageNamed:@"date.jpg"];
    else if([selectedCategory isEqualToString:@"Default"])image = [UIImage imageNamed:@"box.png"];
     [categoryImage setImage:image];
}

- (IBAction)categorySelecting:(id)sender {
    CategoryPickerView.hidden = FALSE;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)return [categoryArray count];
    else return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0)return [categoryArray objectAtIndex:row];
    else return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedCategory = [categoryArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    selectedRow = [pickerView selectedRowInComponent:0];
    
    NSLog(@"row selected is %@", selectedCategory);
}
- (IBAction)touchBackground:(id)sender{
    [Name resignFirstResponder];
    [Place resignFirstResponder];
    [eventfield resignFirstResponder];
}


@end

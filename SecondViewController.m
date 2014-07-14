//
//  SecondViewController.m
//  COREMA
//
//  Created by Vijith Venkatesh on 4/12/14.
//  Copyright (c) 2014 Vijith Venkatesh. All rights reserved.


// this file is responsible to display the settings screen

#import <Foundation/Foundation.h>
#import "SecondViewController.h"

@interface SecondViewController ()

// 4 outlets to track the patient id textfield and 3 datepickers

@property (weak, nonatomic) IBOutlet UITextField *patientId;

@property (weak, nonatomic) IBOutlet UIDatePicker *breakFastTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *lunchTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *dinnerTime;

@end

@implementation SecondViewController

// this method is the action for the save settings button.
- (IBAction)saveSettings:(id)sender {
    
    // save the values from the outlets to instance variables
    self.savedBTime = [self.breakFastTime date];
    self.savedLTime = [self.lunchTime date];
    self.savedDTime = [self.dinnerTime date];

    self.savedPID = [[self.patientId text] intValue];
    NSDateFormatter *timeFormater = [[NSDateFormatter alloc] init];
    [timeFormater setDateFormat:@"hh:mm a"];
    
    // save the settings into the user defaults for persistence

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:self.savedPID forKey:@"patient.id"];
    [defaults setObject:self.savedBTime forKey:@"patient.btime"];
    [defaults setObject:self.savedLTime forKey:@"patient.ltime"];
    [defaults setObject:self.savedDTime forKey:@"patient.dtime"];
    
    // display an alert message
    
    UIAlertView *some = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Your settings have been saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [some show];
}

// this method is to make the keyboard disappear after the textfield editing
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated{
    
    // whenever the screen appears, show the saved settings
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *timeFormater = [[NSDateFormatter alloc] init];
    [timeFormater setDateFormat:@"hh:mm a"];
    
    NSInteger id=[defaults integerForKey:@"patient.id"];
    if(id!=0){
        
        // if the patient id is saved disable the textfield so that it cannot be changed going forward
        self.patientId.text=@(id).stringValue;
        self.patientId.enabled=NO;
    }
    
    NSDate *btime, *ltime, *dtime;
    btime =[defaults objectForKey:@"patient.btime"];
    ltime =[defaults objectForKey:@"patient.ltime"];
    dtime =[defaults objectForKey:@"patient.dtime"];
    
    if(btime!=nil && ltime!=nil && dtime!=nil){
        [self.breakFastTime setDate:btime animated:NO ];
        [self.lunchTime setDate:ltime animated:NO ];
        [self.dinnerTime setDate:dtime animated:NO ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end

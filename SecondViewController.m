//
//  SecondViewController.m
//  COREMA
//
//  Created by Vijith Venkatesh on 4/12/14.
//  Copyright (c) 2014 Vijith Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UITextField *patientId;

@property (weak, nonatomic) IBOutlet UIDatePicker *breakFastTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *lunchTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *dinnerTime;

@end

@implementation SecondViewController

- (IBAction)saveSettings:(id)sender {
    

    self.savedBTime = [self.breakFastTime date];
    self.savedLTime = [self.lunchTime date];
    self.savedDTime = [self.dinnerTime date];

    self.savedPID = [[self.patientId text] intValue];
    
    NSLog(@"Patiend Id: %d ",self.savedPID);
    
    NSDateFormatter *timeFormater = [[NSDateFormatter alloc] init];
    [timeFormater setDateFormat:@"hh:mm a"];
    

    NSLog(@"Breakfast formatted time is %@",[timeFormater stringFromDate:self.savedBTime]);
    NSLog(@"Lunch formatted time is %@",[timeFormater stringFromDate:self.savedLTime]);
    NSLog(@"Dinner formatted time is %@",[timeFormater stringFromDate:self.savedDTime]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSLog(@"Saving the date like below");
    NSLog(@"%@",self.savedBTime);
    NSLog(@"%@",self.savedLTime);
    NSLog(@"%@",self.savedDTime);
 
    [defaults setInteger:self.savedPID forKey:@"patient.id"];
    [defaults setObject:self.savedBTime forKey:@"patient.btime"];
    [defaults setObject:self.savedLTime forKey:@"patient.ltime"];
    [defaults setObject:self.savedDTime forKey:@"patient.dtime"];
    
    UIAlertView *some = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Your settings have been saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [some show];
    
    //NSDate* sourceDate = [NSDate date];
  /*
     NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
     NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
     
     NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self.savedBTime];
     NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self.savedBTime];
     NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
     
     NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self.savedBTime];
     
     NSLog(@"Breakfast time with date is %@",destinationDate);
     [defaults setObject:destinationDate forKey:@"patient.Btime"];
     
     sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self.savedLTime];
     destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self.savedLTime];
     interval = destinationGMTOffset - sourceGMTOffset;
     destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self.savedLTime];
     
     NSLog(@"Lunch time is with date %@",destinationDate);
     [defaults setObject:destinationDate forKey:@"patient.ltime"];
     
     sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self.savedDTime];
     destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self.savedDTime];
     interval = destinationGMTOffset - sourceGMTOffset;
     destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self.savedDTime];
     
     NSLog(@"Dinner time with date is %@",destinationDate);
     [defaults setObject:destinationDate forKey:@"patient.dtime"];
    
    */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated{
    //self.patientId.enabled=NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *timeFormater = [[NSDateFormatter alloc] init];
    [timeFormater setDateFormat:@"hh:mm a"];
    
    NSInteger id=[defaults integerForKey:@"patient.id"];
    if(id!=0){
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

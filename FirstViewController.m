//
//  FirstViewController.m
//  COREMA
//
//  Created by Vijith Venkatesh on 4/12/14.
//  Copyright (c) 2014 Vijith Venkatesh. All rights reserved.



// this file is responsible to display the home screen in the app

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "QnA.h"

@interface FirstViewController ()

@property(strong,nonatomic)NSMutableDictionary *dict;

// variables to track the phase and the patientID
@property(weak,nonatomic)NSString *phase;
@property (nonatomic) NSInteger count;
@property(nonatomic) NSInteger patientID;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dict=[[NSMutableDictionary alloc] init];
    self.count=0;
}

/* this method is called whenver the app becomes active */
- (void)appActivated:(NSNotification *)note
{
    [self viewDidAppear:YES];
}

-(void)viewWillAppear:(BOOL)animated{
 //when app becomes active add this selector
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appActivated:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    // remove the observer when the view disappears
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    
    // clear the screen
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    
    // check the default stored values
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *stringURL;
    NSString *flag=@"YES";
    
    // check if the settings have been saved
    if([defaults objectForKey:@"patient.btime"]== nil || [defaults objectForKey:@"patient.ltime"]== nil || [defaults objectForKey:@"patient.dtime"] == nil|| [defaults integerForKey:@"patient.id"]==0) {
        
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(80,80, 800, 40)];
        label.text = @"Please save your settings in settings tab";
        [self.view addSubview:label];
    }else{
        
        // fetch the saved user settings
        self.patientID=[defaults integerForKey:@"patient.id"];
        NSDate* currentDate = [NSDate date];
        NSDate* savedBtime=[defaults objectForKey:@"patient.btime"];
        NSDate* savedLtime=[defaults objectForKey:@"patient.ltime"];
        NSDate* savedDtime=[defaults objectForKey:@"patient.dtime"];
        
        // take the time part of the date for comparison
        unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:flags fromDate:currentDate];
        
        NSDate* currentTimeOnly = [calendar dateFromComponents:components];
        
        components = [calendar components:flags fromDate:savedBtime];
        NSDate* bTimeOnly=[calendar dateFromComponents:components];
        
        components = [calendar components:flags fromDate:savedLtime];
        NSDate* lTimeOnly=[calendar dateFromComponents:components];
        
        components = [calendar components:flags fromDate:savedDtime];
        NSDate* dTimeOnly=[calendar dateFromComponents:components];
        
        // check the time and set the message label accordingly
        // also set the file from which the questionnaires are to be downloaded
        
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(40,80, 800, 40)];
        if((([currentTimeOnly compare:bTimeOnly]==NSOrderedDescending) &&([currentTimeOnly compare:lTimeOnly]==NSOrderedAscending ))
           ||([currentTimeOnly compare:bTimeOnly]== 0)){
            
            self.phase=@"Morning";
            stringURL = @"https://dl.dropboxusercontent.com/u/102619389/morning.txt";
            label.text = @"Good Morning,please answer the questions, hope this will be a great day ahead";
            if([[defaults objectForKey:@"bQuiz"] isEqualToString:@"YES"]){
                flag=@"NO";
            }
        }else if((([currentTimeOnly compare:lTimeOnly]==NSOrderedDescending) &&([currentTimeOnly compare:dTimeOnly]==NSOrderedAscending ))
                 ||([currentTimeOnly compare:bTimeOnly]==0)){
            
            self.phase=@"Afternoon";
            stringURL =@"https://dl.dropboxusercontent.com/u/102619389/noon.txt";
            label.text = @"Good afternoon, hope your day has been good, here's your questionnaire";
            if([[defaults objectForKey:@"lQuiz"] isEqualToString:@"YES"]){
                flag=@"NO";
            }
        }else{
            self.phase=@"Night";
            stringURL =@"https://dl.dropboxusercontent.com/u/102619389/night.txt";
            label.text = @"Hello Again, hope your day was great, here's your questionnaire";
            if([[defaults objectForKey:@"dQuiz"] isEqualToString:@"YES"]){
                flag=@"NO";
            }
        }
        
        NSLog(@"Phase is %@",self.phase);
        
        
        if([flag isEqualToString:@"YES"])
        {
            [self.view addSubview:label];
            
            // download the file from the url and parse the data
            NSURL  *url = [NSURL URLWithString:stringURL];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                // save the file downloaded in the cache directory
                NSString  *cachesDirectory = [paths objectAtIndex:0];
                
                NSString *filePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"vijmorning.txt"]];
                [urlData writeToFile:filePath atomically:YES];
                
                NSString *fileContents = [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
                NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
                
                // create a mutable array of questionset
                NSMutableArray *questionSet = [[NSMutableArray alloc] init];
                
                
                for (long i=0; i<lines.count; i++) {
                    // parse based on the delimeter #
                    NSArray *catQues = [lines[i] componentsSeparatedByString:@"#"];
                    // create a question and answer object
                    QnA *qna = [[QnA alloc]init];
                    if(catQues.count>1){
                        // populate, question category and answers to the object
                        qna.category=catQues[0];
                        qna.question=catQues[1];
                        qna.answers=[[NSMutableArray alloc] init];
                        long step=(long)[catQues[2] integerValue];
                        for (long j=i+1; j<=(step+i); j++) {
                            [qna.answers addObject:lines[j]];
                        }
                        i=i+step;
                        // add the object to the questionset
                        [questionSet addObject:qna];
                    }
                }
                // set the offsets for the screen
                self.count=questionSet.count;
                int xOffset=40;
                int yOffset=150;
                
                // display all the questions along with their options
                for (QnA *qna2 in questionSet ) {
                    
                    
                    UILabel *lbl1 = [[UILabel alloc] init];
                    CGSize maximumLabelSize = CGSizeMake(310, 9999);
                    
                    lbl1.font=[UIFont fontWithName:@"HelveticaNeue" size:18];
                    lbl1.text=qna2.question;
                    CGSize s=[lbl1 sizeThatFits:maximumLabelSize];
                    
                    // display the question as a label
                    [lbl1 setFrame:CGRectMake(xOffset,yOffset,s.width,s.height)];
                    lbl1.backgroundColor=[UIColor clearColor];
                    lbl1.textColor=[UIColor blackColor];
                    lbl1.userInteractionEnabled=YES;
                    lbl1.text= qna2.question;
                    [self.view addSubview:lbl1];
                    yOffset+=30;
                    
                    
                    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:18];
                    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
                    
                    // display options as segmented control on the screen
                    NSArray *optionsArray =[NSArray arrayWithArray:qna2.answers];
                    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:optionsArray];
                    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
                    segmentedControl.frame = CGRectMake(xOffset,yOffset, 220, 40);
                    [segmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
                    
                    yOffset+=75;
                    // add this hint to track the category of the question being answered
                    segmentedControl.accessibilityHint=qna2.category;
                    
                    // display the options
                    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
                    [self.view addSubview:segmentedControl];
                    
                }
                yOffset+=40;
                
                
                // display the submit button
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self action:@selector(SubmitAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"Submit" forState:UIControlStateNormal];
                button.frame = CGRectMake(290.0,yOffset, 160.0, 40.0);
                [self.view addSubview:button];
                
            }
            
        }else{
            // display this message if the question has been answered for this session already
            UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(80,80, 800, 40)];
            label.text = @"Hi, you have already answered your questionnaire for this period, Thanks.";
            [self.view addSubview:label];
        }
        
    }
}

- (IBAction)MySegmentControlAction:(id)sender
{
    // check which option has been selected by the user
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSLog(@"%@ : %@",segmentedControl.accessibilityHint,[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]);
    
    // add the selected option along with the category to the custom dictionary
    [self.dict setObject:[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex] forKey:segmentedControl.accessibilityHint];
    
}

- (IBAction)SubmitAction:(id)sender{
    
    // check if all the questions have been answered
    if(self.dict.count!=self.count){
        UIAlertView *some = [[UIAlertView alloc] initWithTitle:@"Incomplete" message:@"Please answer all the questions" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [some show];
    }else{
        // set the patient id and phase to the dictionary
        [self.dict setObject:[NSNumber numberWithInteger:self.patientID] forKey:@"Patient_id"];
        
        [self.dict setObject:self.phase forKey:@"Phase"];
        
        NSDate* currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSString *stringFromDate = [formatter stringFromDate:currentDate];
        
        NSLog(@"final date is %@",stringFromDate);
        
        [self.dict setObject:stringFromDate forKey:@"Reading_time"];
        
        // Create the request operation manager
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        // Set the  request serializer to JSON (not sure if it is the default...)
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        
        // Same for the response serializer...
        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        
        // Set the authorization fields
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(@"e2013343@drdrb.com") password:(@"rpcs2014")];
        
        // Set the application header
        [manager.requestSerializer setValue:(@"cor") forHTTPHeaderField:(@"X-DreamFactory-Application-Name")];
        
        // Set the Accept-Language header
        [manager.requestSerializer setValue:(nil) forHTTPHeaderField:(@"Accept-Language")];
        
        NSDictionary *jsonMetaDict = @{@"count": @1};
        NSDictionary *jsonDict = @{@"record":self.dict, @"meta":jsonMetaDict};
        
        NSLog(@"%@",jsonDict);
        
        assert([NSJSONSerialization isValidJSONObject:jsonDict]);
        
        // POST the data -- for now just print out the response
        [manager POST:(@"https://dsp-e2013343.cloud.dreamfactory.com/rest/cor/ema")
         
           parameters:(jsonDict)
         
         // if the submit is successful, display a success alert box
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"JSON: %@", responseObject);
                  UIAlertView *some = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your response has been sent, see you at the next questionnaire, keep up the good work" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [some show];
                  
                  // remove all the questions from the view
                  for (UIView *view in [self.view subviews]) {
                      [view removeFromSuperview];
                  }
                  // set the message telling the status of the survey
                  UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(80,80, 800, 40)];
                  label.text = @"See you at the next questtionaire, keep up the good work";
                  [self.view addSubview:label];
                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                  if([self.phase isEqualToString:@"Morning"]){
                      [defaults setObject:@"YES" forKey:@"bQuiz"];
                      [defaults setObject:@"NO" forKey:@"dQuiz"];
                  }else if([self.phase isEqualToString:@"Afternoon"]){
                      [defaults setObject:@"YES" forKey:@"lQuiz"];
                      [defaults setObject:@"NO" forKey:@"bQuiz"];
                  }else{
                      [defaults setObject:@"YES" forKey:@"dQuiz"];
                      [defaults setObject:@"NO" forKey:@"lQuiz"];
                  }
              }
         
                // display the failure message
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  UIAlertView *some = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"There was some error, please try after some time" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [some show];
              }
         ];
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  QnA.m
//  COREMA
//
//  Created by Vijith Venkatesh on 4/13/14.
//  Copyright (c) 2014 Vijith Venkatesh. All rights reserved.
//  Group members Vijith, Adwaith, Shreya, Aditya


#import "QnA.h"

@implementation QnA

// this is the method which is used to display question and answer object completely
- (NSString *)description{
    return [NSString stringWithFormat:@"Category=%@ \r Question =%@ \r Answers = %@",self.category,self.question,self.answers];
}
@end

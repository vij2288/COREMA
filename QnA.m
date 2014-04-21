//
//  QnA.m
//  COREMA
//
//  Created by Vijith Venkatesh on 4/13/14.
//  Copyright (c) 2014 Vijith Venkatesh. All rights reserved.
//

#import "QnA.h"

@implementation QnA
- (NSString *)description{
    return [NSString stringWithFormat:@"Category=%@ \r Question =%@ \r Answers = %@",self.category,self.question,self.answers];
}
@end

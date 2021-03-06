//
//  QnA.h
//  COREMA
//
//  Created by Vijith Venkatesh on 4/13/14.
//  Copyright (c) 2014 Vijith Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>

// this object contains variables to track question, category and answers
@interface QnA : NSObject
    @property NSString *category;
    @property NSString *question;
    @property NSMutableArray *answers;
@end

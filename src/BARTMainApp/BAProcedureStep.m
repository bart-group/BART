//
//  BAProcedureStep.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 7/28/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAProcedureStep.h"


@implementation BAProcedureStep

@synthesize configureComplete;
@synthesize workDone;

- (id)init
{
    self = [super init];
    if (self) {
        configureComplete = NO;
        workDone = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end

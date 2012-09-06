//
//  BAExampleStep.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/5/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAExampleStep.h"

@implementation BAExampleStep

- (id)initWithNameAndComment:(NSString *)name comment:(NSString *)comment
{
    if(self = [super initWithNameAndComment:name comment:comment])
    {
        [[self properties] setObject:@"BAExampleStepConfigView" forKey: BA_ELEMENT_PROPERTY_CONFIGURATION_UI_NAME];
    }
    
    return self;
}

@end

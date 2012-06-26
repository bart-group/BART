//
//  BAStep2.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAStep2.h"


@implementation BAStep2

#pragma mark -
#pragma mark Global Properties

@synthesize name        = _name;
@synthesize description = _description;
@synthesize state       = _state;

#pragma mark -
#pragma mark Local Properties

@synthesize experiment = _experiment;


#pragma mark -
#pragma mark Initialization

- (id) initWithName:(NSString *)name description:(NSString *)description
{
    if(self = [super init]) {
        _name        = [name copy];
        _description = [description copy];
    }
    
    return self;
}


@end

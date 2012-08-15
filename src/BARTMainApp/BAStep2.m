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


- (void)setState:(NSInteger)state
{
    [self willChangeValueForKey:@"state"];

    NSLog(@"Step changing state from %lu to %lu", _state, state);
    _state = state;
    
    [self didChangeValueForKey:@"state"];
}


#pragma mark -
#pragma mark Initialization

- (id) initWithExperiment:(BAExperiment2*)experiment name:(NSString*)name description:(NSString*)description;
{
    if(self = [super init]) {
        _name        = [name copy];
        _description = [description copy];
        _experiment  = [experiment retain];
    }
    
    return self;
}


+ (NSString*)typeDisplayName
{
    return @"Abstract Step";
}

+ (NSString*)typeDescription
{
    return @"Abstract Step Description";
}

@end

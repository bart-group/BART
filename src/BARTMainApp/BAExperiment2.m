//
//  BAExperiment2.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAExperiment2.h"

#import "BAStep2.h"


@implementation BAExperiment2

#pragma mark -
#pragma mark Global Properties

@synthesize name        = _name;
@synthesize description = _description;
@synthesize state       = _state;

#pragma mark -
#pragma mark Local Properties

@synthesize steps   = _steps;
@synthesize session = _session;

#pragma mark -
#pragma mark Initialization

- (id) initWithName:(NSString *)name description:(NSString *)description
{
    return [self initWithName:name description:description steps:nil];
}

- (id) initWithName:(NSString *)name description:(NSString *)description steps:(NSArray *)steps
{
    if(self = [super init]) {
        _name        = [name copy];
        _description = [description copy];
        [self setSteps:steps];
    }
    
    return self;
}

#pragma mark -
#pragma mark Property Methods 'steps'

- (NSArray*) steps
{
    return _steps;
}

- (void) setSteps:(NSArray *)steps
{
    [self willChangeValueForKey:@"steps"];

    _steps = steps;
    [_steps enumerateObjectsUsingBlock:^(id step, NSUInteger index, BOOL *stop) {
        [(BAStep2*)step setExperiment:self];
    }];
    
    [self didChangeValueForKey:@"steps"];
}

- (NSUInteger) countOfSteps
{
    return [_steps count];
}

- (id) objectInStepsAtIndex:(NSUInteger)index
{
    return [_steps objectAtIndex:index];
}

- (void) getSteps:(BAExperiment2 **)buffer range:(NSRange)inRange
{
    [_steps getObjects:buffer range:inRange];
}


@end

//
//  BASession2.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASession2.h"

#import "BAExperiment2.h"


@implementation BASession2

#pragma mark -
#pragma mark Global Properties

@synthesize name        = _name;
@synthesize description = _description;
@synthesize state       = _state;

#pragma mark -
#pragma mark Local Properties

@synthesize experiments = _experiments;

#pragma mark -
#pragma mark Initialization

- (id) initWithName:(NSString *)name description:(NSString *)description
{
    return [self initWithName:name description:description experiments:nil];
}

- (id) initWithName:(NSString *)name description:(NSString *)description experiments:(NSArray *)experiments
{
    if(self = [super init]) {
        _name        = [name copy];
        _description = [description copy];
        [self setExperiments:experiments];
    }
    
    return self;
}


#pragma mark -
#pragma mark Property Methods 'experiments'

- (NSArray*) experiments
{
    return _experiments;
}

- (void) setExperiments:(NSArray *)experiments
{
    _experiments = experiments;
}

- (NSUInteger) countOfExperiments
{
    return [_experiments count];
}

- (id) objectInExperimentsAtIndex:(NSUInteger)index
{
    return [_experiments objectAtIndex:index];
}

- (void) getExperiments:(BAExperiment2 **)buffer range:(NSRange)inRange
{
    [_experiments getObjects:buffer range:inRange];
}

@end

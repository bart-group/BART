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
    return [super initWithType:BA_NODE_TYPE_SESSION name:name description:description children:experiments];
}


#pragma mark -
#pragma mark Property Methods 'experiments'

- (NSArray*) experiments
{
    return [self children];
}

- (void) setExperiments:(NSArray *)experiments
{
    [self willChangeValueForKey:@"experiments"];
    
    _experiments = experiments;
    [_experiments enumerateObjectsUsingBlock:^(id experiment, NSUInteger index, BOOL *stop) {
        [(BAExperiment2*)experiment setSession:self];
    }];
    
    [self didChangeValueForKey:@"experiments"];
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


#pragma mark -
#pragma mark Class Methods

+ (NSString*)displayTypeName
{
    return @"Abstract Session";
}

@end

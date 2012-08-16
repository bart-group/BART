//
//  BAExperiment2.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAExperiment2.h"
#import "BAStep2.h"

#import <objc/runtime.h>



@implementation BAExperiment2

#pragma mark -
#pragma mark Global Properties

@synthesize name        = _name;
@synthesize description = _description;
@synthesize edl         = _edl;
@synthesize state       = _state;

#pragma mark -
#pragma mark Local Properties

@synthesize steps   = _steps;
@synthesize session = _session;

#pragma mark -
#pragma mark Initialization

+ (id) experimentWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description
{
    return [[[self alloc] initWithEDL:edl name:name description:description] autorelease];
}

- (id) initWithEDL:(COSystemConfig*)edl name:(NSString *)name
{
    return [self initWithEDL:edl name:name description:name steps:nil];
}

- (id) initWithEDL:(COSystemConfig*)edl name:(NSString *)name description:(NSString *)description
{
    return [self initWithEDL:edl name:name description:description steps:nil];
}

- (id) initWithEDL:(COSystemConfig*)edl name:(NSString *)name description:(NSString *)description steps:(NSArray *)steps
{
    if(self = [super init]) {
        _name        = [name copy];
        _description = [description copy];
        _edl         = [edl retain];
        [self setSteps:steps];
    }
    
    return self;
}

#pragma mark -
#pragma mark Property Methods 'steps'

- (NSArray*)steps
{
    return _steps;
}

- (void) setSteps:(NSArray*)steps
{
    [self willChangeValueForKey:@"steps"];

    _steps = steps;
    [_steps enumerateObjectsUsingBlock:^(id step, NSUInteger index, BOOL *stop) {
        [(BAStep2*)step setExperiment:self];
    }];
    
    [self didChangeValueForKey:@"steps"];
}

- (NSUInteger)countOfSteps
{
    return [_steps count];
}

- (id)objectInStepsAtIndex:(NSUInteger)index
{
    return [_steps objectAtIndex:index];
}

- (void)getSteps:(BAExperiment2 **)buffer range:(NSRange)inRange
{
    [_steps getObjects:buffer range:inRange];
}

- (void)insertObject:(BAStep2*)step inStepsAtIndex:(NSUInteger)index
{
    [[self mutableArrayValueForKey:@"steps"] insertObject:step atIndex:index];
}

- (void)removeObjectFromStepsAtIndex:(NSUInteger)index
{
    [[self mutableArrayValueForKey:@"steps"] removeObjectAtIndex:index];
}

- (void)replaceObjectInStepsAtIndex:(NSUInteger)index withObject:(id)step
{
    [[self mutableArrayValueForKey:@"steps"] replaceObjectAtIndex:index withObject:step];
}

#pragma mark -
#pragma mark Instance Methods (Structure)

- (void)appendStep:(id)step
{
    [self insertObject:step inStepsAtIndex:[self countOfSteps]];
}


#pragma mark -
#pragma mark Class Methods

+ (NSString*)typeDisplayName
{
    return @"Abstract Experiment";
}

+ (NSString*)typeDescription
{
    return @"Abstract Experiment Description";
}

+ (NSArray*)subclasses
{
    NSMutableArray *subClasses = [NSMutableArray array];
    Class *classes = nil;
    int count = objc_getClassList(NULL, 0);
    if(count) {
        classes = malloc(sizeof(Class)* count); 
        NSAssert(classes != NULL, @"Memory Allocation Failed in [Content +subclasses].");
        (void) objc_getClassList(classes, count); 
    }
    if (classes) {
        for(int i=0; i<count; i++) {
            Class myClass = classes[i]; 
            Class superClass = class_getSuperclass(myClass);
            char *name = class_getName(myClass);
            // take all our subclasses except the generated classes beginning with 'NSKVONotifying...'
            if(superClass == [self class] && [[NSString stringWithUTF8String:name] rangeOfString:@"NSKVONotifying"].location == NSNotFound) {
                NSLog(@"Found Class: %@", [NSString stringWithUTF8String:name]);
                [subClasses addObject:myClass];
            }
        }
        free(classes);
    }
    return subClasses;
}


@end

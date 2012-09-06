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



@implementation BAExperiment2 {
    
    NSMutableArray *_steps;
    
    NSDictionary *globalObjectTable;
}

#pragma mark -
#pragma mark Global Properties

@synthesize edl         = _edl;

#pragma mark -
#pragma mark Local Properties

@synthesize steps   = _steps;
@synthesize session = _session;

#pragma mark -
#pragma mark Initialization and Destruction

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
    if(self = [super initWithType:BA_NODE_TYPE_EXPERIMENT name:name description:description children:steps]) {
        _edl = [edl retain];
    }
    
    if(steps == nil) {
        _steps = [[NSMutableArray arrayWithCapacity:0] retain];
    } else {
        _steps = [[NSMutableArray arrayWithArray:steps] retain];
    }
    
    // init global object table
    globalObjectTable = [[NSDictionary alloc] initWithObjectsAndKeys:nil];
    
    return self;
}

- (void)dealloc
{
    [globalObjectTable release];
    [super dealloc];
}


#pragma mark -
#pragma mark Property Methods 'steps'

- (NSArray*)children
{
    return [self steps];
}

- (void) setSteps:(NSArray*)steps
{
    [self willChangeValueForKey:@"steps"];

    _steps = [NSMutableArray arrayWithArray:steps];
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
    [self willChangeValueForKey:@"steps"];
    NSLog(@"insertObject:%@ inStepsAtIndex:%lu", step, index);
    [step setExperiment:self];
    [_steps insertObject:step atIndex:index];
    [self didChangeValueForKey:@"steps"];
}

- (void)removeObjectFromStepsAtIndex:(NSUInteger)index
{
    [self willChangeValueForKey:@"steps"];
    [_steps removeObjectAtIndex:index];
    [self didChangeValueForKey:@"steps"];
}

- (void)replaceObjectInStepsAtIndex:(NSUInteger)index withObject:(id)step
{
    [self willChangeValueForKey:@"steps"];
    [step setExperiment:self];
    [_steps replaceObjectAtIndex:index withObject:step];
    [self didChangeValueForKey:@"steps"];
}

#pragma mark -
#pragma mark Instance Methods (Structure)

- (void)appendStep:(id)step
{
    [self insertObject:step inStepsAtIndex:[self countOfSteps]];
}

#pragma mark -
#pragma mark Instance Methods (Global Objects)

- (void)addObjectToGlobalTable:(id)object name:(NSString*)name
{
    [globalObjectTable setValue:object forKey:name];
}

- (id)objectFromGlobalTable:(NSString*)name
{
    return [globalObjectTable objectForKey:name];
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

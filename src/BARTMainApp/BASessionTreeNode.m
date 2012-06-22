//
//  BASessionTreeNode.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeNode.h"

#import "BASession2.h"
#import "BAExperiment2.h"
#import "BAStep2.h"


@implementation BASessionTreeNode


@synthesize object      = _object;
@synthesize children    = _children;
@synthesize type        = _type;
@synthesize state       = _state;
@synthesize name        = _name;
@synthesize description = _description;


- (NSImage*)typeIcon
{
    if(_type == BA_NODE_TYPE_SESSION) {
        return [NSImage imageNamed:@"SessionTreeNodeIconSession.png"];
    } else if (_type == BA_NODE_TYPE_EXPERIMENT) {
        return [NSImage imageNamed:@"SessionTreeNodeIconExperiment.png"];
    } else if (_type == BA_NODE_TYPE_STEP) {
        return [NSImage imageNamed:@"SessionTreeNodeIconStep.png"];
    } else {
        return [NSImage imageNamed:@"SessionTreeNodeIconUnknown.png"];
    }
}


- (NSImage*)stateIcon
{
    
    return nil;
}


- (id)initWithObject:(id)object children:(NSArray*)children
{
    if(self = [super init]) {
        _object = object;
        _children = [NSArray arrayWithArray:children];
        if([[_object class] isSubclassOfClass:[BASession2 class]]) {
            _type = BA_NODE_TYPE_SESSION;
        } else if ([[_object class] isSubclassOfClass:[BAExperiment2 class]]) {
            _type = BA_NODE_TYPE_EXPERIMENT;
        } else if ([[_object class] isSubclassOfClass:[BAStep2 class]]) {
            _type = BA_NODE_TYPE_STEP;
        } else {
            _type = BA_NODE_TYPE_UNKNOWN;
        }
        _name        = [[_object name] copy];
        _description = [[_object description] copy];
        _state       = [_object state];
        [_object addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    }
    
    return self;
}


- (void)dealloc
{
    [_object removeObserver:self forKeyPath:@"state"];
    [super dealloc];
}

-(BOOL)isRoot
{
    return _type == BA_NODE_TYPE_SESSION;
}


-(BOOL)isLeaf
{
    return (_children == nil || [_children count] == 0);
}


-(NSUInteger)childCount
{
    return [_children count];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(_object == object && [keyPath isEqualToString:@"state"]) {
        _state = (NSInteger)[change objectForKey:NSKeyValueChangeNewKey];
    }
}

@end

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


+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSLog(@"[BASessionTreeNode keyPathsForValuesAffectingValueForKey]: %@", key);

    if([key compare:@"stateIcon"] == NSOrderedSame) {
        return [NSSet setWithObjects:@"state", @"object.state", nil];
    }
    
    return nil;
}


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
    if([[self object] state] == BA_NODE_STATE_RUNNING) {
        return [NSImage imageNamed:@"runner.png"];
    } else if ([[self object] state] == BA_NODE_STATE_READY) {
        return [NSImage imageNamed:NSImageNameStatusAvailable];
    } else if ([[self object] state] == BA_NODE_STATE_NEEDS_CONFIGURATION) {
        return [NSImage imageNamed:NSImageNameStatusPartiallyAvailable];
    } else if ([[self object] state] == BA_NODE_STATE_ERROR) {
        return [NSImage imageNamed:NSImageNameStatusUnavailable];
    } else if ([[self object] state] == BA_NODE_STATE_FINISHED) {
        return [NSImage imageNamed:NSImageNameMenuOnStateTemplate];
    } else {
        return [NSImage imageNamed:NSImageNameStatusNone];
    }
}


- (id)initWithType:(BASessionTreeNodeType)type name:(NSString*)name description:(NSString*)description children:(NSArray*)children
{
    if(self = [super init]) {
        if(children == nil) {
            _children = [[NSArray arrayWithObjects:nil] retain];
        } else {
            _children = [[NSArray arrayWithArray:children] retain];
        }
        _type        = type;
        _name        = [name copy];
        _description = [description copy];
        _state       = BA_NODE_STATE_UNKNOWN;
        NSLog(@"Created BASessionTreeNode:");
        NSLog(@"           type: %@", _type);
        NSLog(@"           name: %@", _name);
        NSLog(@"    description: %@", _description);
        NSLog(@"          state: %@", _state);
        NSLog(@"       children: %@", _children);
        
    }
    
    return self;
}


- (id)initWithObject:(id)object children:(NSArray*)children
{
    if(self = [super init]) {
        _object = object;
        if(children == nil) {
            _children = [[NSArray arrayWithObjects:nil] retain];
        } else {
            _children = [[NSArray arrayWithArray:children] retain];
        }
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
        NSLog(@"Created BASessionTreeNode:");
        NSLog(@"           name: %@", _name);
        NSLog(@"    description: %@", _description);
        NSLog(@"          state: %@", _state);
        NSLog(@"       children: %@", _children);
        
//        [_object addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    }
    
    return self;
}


- (void)dealloc
{
//    [_object removeObserver:self forKeyPath:@"state"];
    [super dealloc];
}

-(BOOL)isRoot
{
    NSLog(@"[BASessionTreeNode isRoot] called");
    return _type == BA_NODE_TYPE_SESSION;
}


-(BOOL)isLeaf
{
    NSLog(@"[BASessionTreeNode isLeaf] called (%@)", _name);
    return (_children == nil || [_children count] == 0);
}


-(NSUInteger)childCount
{
    NSLog(@"[BASessionTreeNode childCount] called");
    return [_children count];
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if(_object == object && [keyPath isEqualToString:@"state"]) {
//        _state = (NSInteger)[change objectForKey:NSKeyValueChangeNewKey];
//    }
//}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end

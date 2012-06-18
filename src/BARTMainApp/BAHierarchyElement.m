//
//  BAHierarchyElement.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/14/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAHierarchyElement.h"


@implementation BAHierarchyElement

NSString * const BA_ELEMENT_PROPERTY_NAME    = @"ba.element.property.name";
NSString * const BA_ELEMENT_PROPERTY_COMMENT = @"ba.element.property.comment";
NSString * const BA_ELEMENT_PROPERTY_STATE   = @"ba.element.property.state";
NSString * const BA_ELEMENT_PROPERTY_UUID    = @"ba.element.property.uuid";

NSString * const BA_ELEMENT_PROPERTY_CONFIGURATION_UI_NAME = @"ba.element.property.configuration.ui.name";
NSString * const BA_ELEMENT_PROPERTY_EXECUTION_UI_NAME     = @"ba.element.property.execution.ui.name";

NSString * const BA_ELEMENT_PROPERTY_CONFIGURATION_UI_CONTROLLER = @"ba.element.property.configuration.ui.controller";
NSString * const BA_ELEMENT_PROPERTY_EXECUTION_UI_CONTROLLER     = @"ba.element.property.execution.ui.controller";

NSInteger  const BA_ELEMENT_STATE_UNKNOWN        = 0x0;
NSInteger  const BA_ELEMENT_STATE_ERROR          = 0x1;
NSInteger  const BA_ELEMENT_STATE_NOT_CONFIGURED = 0x2;
NSInteger  const BA_ELEMENT_STATE_READY          = 0x3;
NSInteger  const BA_ELEMENT_STATE_RUNNING        = 0x4;
NSInteger  const BA_ELEMENT_STATE_FINISHED       = 0x5;

NSInteger  const BA_ELEMENT_EXECUTION_RESULT_OK    = 0x0;
NSInteger  const BA_ELEMENT_EXECUTION_RESULT_ERROR = 0x1;


NSString            *uuid;
NSMutableDictionary *properties;
NSMutableArray      *children;
BAHierarchyElement  *parent;


@synthesize properties=properties, parent=parent, children=children, uuid=uuid;
@synthesize typeIcon, stateIcon;

-(NSString*)name
{
    return [[self properties] objectForKey:BA_ELEMENT_PROPERTY_NAME];
}

-(NSString*)comment
{
    return [[self properties] objectForKey:BA_ELEMENT_PROPERTY_COMMENT];
}

-(NSInteger)state
{
    return [[[self properties] objectForKey:BA_ELEMENT_PROPERTY_STATE] integerValue];
}

-(void)setState:(NSInteger)newState
{
    [self willChangeValueForKey:@"state"];

    if(newState != BA_ELEMENT_STATE_ERROR &&
       newState != BA_ELEMENT_STATE_FINISHED &&
       newState != BA_ELEMENT_STATE_READY &&
       newState != BA_ELEMENT_STATE_NOT_CONFIGURED &&
       newState != BA_ELEMENT_STATE_RUNNING) {
        newState = BA_ELEMENT_STATE_UNKNOWN;
    }
    [[self properties] setObject:[NSNumber numberWithInteger:newState] forKey:BA_ELEMENT_PROPERTY_STATE];
    
    [self didChangeValueForKey:@"state"];
}

-(NSString*)uuid
{
    return [[self properties] objectForKey:BA_ELEMENT_PROPERTY_UUID];
}

-(NSImage*)typeIcon
{
    return [NSImage imageNamed:@"Hierarchy Element Icon Unknown.png"];
}

-(NSImage*)stateIcon
{
//    NSLog(@"stateIcon getter called for element %@", [self description]);
    if([self state] == BA_ELEMENT_STATE_RUNNING) {
        return [NSImage imageNamed:NSImageNameStatusAvailable];
    } else if([self state] == BA_ELEMENT_STATE_READY) {
        return [NSImage imageNamed:NSImageNameStatusPartiallyAvailable];
    } else if([self state] == BA_ELEMENT_STATE_FINISHED) {
        return [NSImage imageNamed:NSImageNameMenuOnStateTemplate];
    } else if([self state] == BA_ELEMENT_STATE_UNKNOWN) {
        return [NSImage imageNamed:NSImageNameStatusNone];
    } else {
        return [NSImage imageNamed:NSImageNameStatusUnavailable];
    }

}

// register 'stateIcon' as dependent key for 'state'
+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if([key isEqualToString:@"stateIcon"]) {
        return [keyPaths setByAddingObjectsFromSet:[NSSet setWithObjects:@"state", nil]];
    }
    
    return keyPaths;
}


-(id)init
{
    return [self initWithName: NSStringFromClass([self class])];
}

-(id)initWithName:(NSString *)name
{
    return [self initWithName: name comment:NSStringFromClass([self class])];
}

-(id)initWithName:(NSString *)name comment:(NSString *)comment
{
    if(self = [super init]) {
        properties = [[NSMutableDictionary alloc] init];
        children   = [[NSMutableArray alloc] init];
        parent     = nil;
        uuid       = [[NSProcessInfo processInfo] globallyUniqueString];
        [properties setObject: name forKey: BA_ELEMENT_PROPERTY_NAME];
        [properties setObject: comment forKey: BA_ELEMENT_PROPERTY_COMMENT];
        [properties setObject: [NSNumber numberWithInteger: BA_ELEMENT_STATE_UNKNOWN] forKey: BA_ELEMENT_PROPERTY_STATE];
        [properties setObject: uuid forKey: BA_ELEMENT_PROPERTY_UUID];
    }
    
    NSLog(@"Hierarchy Element created: %@", [self description]);
    
    return self;
}

-(BOOL)isRoot
{
    return parent == nil;
}

-(BOOL)isLeaf
{
    return (children == nil || [children count] == 0);
}

-(BOOL)equals:(BAHierarchyElement*)otherElement
{
    return ([[self uuid] compare:[otherElement uuid]] == NSOrderedSame);
}

-(NSUInteger)childCount
{
    return [children count];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@: %@ (%@, uuid: %@, state: %i)", NSStringFromClass([self class]), [self name], [self comment], [self uuid], [self state]];
}

-(NSInteger)execute
{
    return BA_ELEMENT_EXECUTION_RESULT_OK;
}

-(BOOL)isReady
{
    if([self isLeaf]) {
        return ([self state] == BA_ELEMENT_STATE_READY);
    }
    
    BOOL ready = ([self state] == BA_ELEMENT_STATE_READY);
    NSEnumerator *allChildren = [[self children] objectEnumerator];
    BAHierarchyElement *element;
    while((element = (BAHierarchyElement*)[allChildren nextObject])) {
        ready &= ([element state] == BA_ELEMENT_STATE_READY);
    }
    
    return ready;
}

-(id)copyWithZone:(NSZone *)zone
{
    // NSLog(@"inside copyWithZone [%@]", [self description]);
    return self;
}


@end

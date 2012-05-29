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

NSInteger  const BA_ELEMENT_STATE_UNKNOWN        = 0x0;
NSInteger  const BA_ELEMENT_STATE_ERROR          = 0x1;
NSInteger  const BA_ELEMENT_STATE_NOT_CONFIGURED = 0x2;
NSInteger  const BA_ELEMENT_STATE_READY          = 0x3;
NSInteger  const BA_ELEMENT_STATE_RUNNING        = 0x4;
NSInteger  const BA_ELEMENT_STATE_FINISHED       = 0x5;


uuid_t               uuid;
NSMutableDictionary *properties;
NSMutableArray      *children;
BAHierarchyElement  *parent;


@synthesize properties=properties, parent=parent, children=children;


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

-(NSString*)uuid
{
    uuid_string_t uuid_string;
    uuid_unparse(uuid, uuid_string);
    return [NSString stringWithUTF8String:uuid_string];
}

-(id)init
{
    return [self initWithName: NSStringFromClass([self class])];
}

-(id)initWithName:(NSString *)name
{
    return [self initWithNameAndComment: name comment:NSStringFromClass([self class])];
}

-(id)initWithNameAndComment:(NSString *)name comment:(NSString *)comment
{
    if(self = [super init]) {
        properties = [[NSMutableDictionary alloc] init];
        children   = [[NSMutableArray alloc] init];
        parent     = nil;
        [properties setObject: name forKey: BA_ELEMENT_PROPERTY_NAME];
        [properties setObject: comment forKey: BA_ELEMENT_PROPERTY_COMMENT];
        [properties setObject: [NSNumber numberWithInteger: BA_ELEMENT_STATE_UNKNOWN] forKey: BA_ELEMENT_PROPERTY_STATE];
        uuid_generate(uuid);
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

-(NSUInteger)childCount
{
    return [children count];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@: %@ (%@, uuid: %@, state: %i)", NSStringFromClass([self class]), [self name], [self comment], [self uuid], [self state]];
}

@end

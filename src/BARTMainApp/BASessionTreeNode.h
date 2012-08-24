//
//  BASessionTreeNode.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "BAConstants.h"


@interface BASessionTreeNode : NSObject <NSCopying>
    

@property (readonly) id                     object;
@property (readonly) NSString              *name;
@property (readonly) NSString              *description;
@property (readonly) BASessionTreeNodeType  type;
@property (readonly) NSImage               *typeIcon;
@property (readonly) NSInteger              state;
@property (readonly) NSImage               *stateIcon;
@property (readonly) NSArray               *children;


- (id)initWithObject:(id)object children:(NSArray*)children;
- (id)initWithType:(BASessionTreeNodeType)type name:(NSString*)name description:(NSString*)description children:(NSArray*)children;


-(BOOL)isRoot;
-(BOOL)isLeaf;
-(NSUInteger)childCount;


@end

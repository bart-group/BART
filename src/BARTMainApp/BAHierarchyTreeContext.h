/*
 *	BAHierarchyTreeContext.h
 *	BARTApplication
 *	
 *	Created by Torsten Schlumm on 5/15/12.
 *	Copyright 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "BAHierarchyElement.h"


@interface BAHierarchyTreeContext : NSObject
{
@private
}

@property (readonly,getter = instance) BAHierarchyTreeContext*    sharedContext;
@property (copy,readwrite)             BAHierarchyElement*        rootElement;

@property (nonatomic,retain,readwrite) BAHierarchyElement*        selectedElement;


+ (BAHierarchyTreeContext *) instance;


- (NSInteger)loadSessionTree:(NSString*)treeDescriptionPath withEDL:(NSString*)edlPath;

- (NSInteger)execute:(BAHierarchyElement*)element;


@end
/*
 *	BAHierarchyTree.h
 *	BARTApplication
 *	
 *	Created by Torsten Schlumm on 5/15/12.
 *	Copyright 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "BAHierarchyElement.h"


@interface BAHierarchyTree : NSObject
{
@private
}

@property (readonly,getter = instance) BAHierarchyTree*    sharedTree;
@property (copy,readwrite)             BAHierarchyElement* rootElement;


+ (BAHierarchyTree *) instance;

@end